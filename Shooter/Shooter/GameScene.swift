//
//  GameScene.swift
//  Shooter
//
//  Created by Ma Xueyuan on 2020/06/22.
//  Copyright © 2020 Ma Xueyuan. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    let timeLimit = 20.0
    let interval = 0.5
    
    var bulletNodes = [SKNode]()
    var fireLabel: SKNode!
    var reloadLabel: SKNode!
    var gameOverLabel: SKNode!
    var scoreLabel: SKLabelNode!
    var targetNode: SKNode!
    
    var gameOverTimer: Timer?
    var enemyAppearTimer: Timer?
    var fingerBeginPoint = CGPoint.zero
    var targetBeginPoint = CGPoint.zero
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var isGameOver = false {
        didSet {
            gameOverLabel.isHidden = !isGameOver
        }
    }
    
    var bullets = 6 {
        didSet {
            for (i, bulletNode) in bulletNodes.enumerated() {
                if i < bullets {
                    bulletNode.isHidden = false
                } else {
                    bulletNode.isHidden = true
                }
            }
        }
    }
    
    override func didMove(to view: SKView) {
        // configure bullets
        for i in 1...6 {
            let bulletNode = childNode(withName: "bullet\(i)")!
            bulletNodes.append(bulletNode)
        }
        
        // configure labels
        fireLabel = childNode(withName: "Fire")
        reloadLabel = childNode(withName: "Reload")
        gameOverLabel = childNode(withName: "gameOver")
        scoreLabel = (childNode(withName: "score") as! SKLabelNode)
        
        // configure target
        targetNode = childNode(withName: "target")
        
        // start the enemy appear timer
        enemyAppearTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(enemyAppear), userInfo: nil, repeats: true)
        
        // start the game over timer
        gameOverTimer = Timer.scheduledTimer(withTimeInterval: timeLimit, repeats: false, block: { [weak self] (_) in
            self?.isGameOver = true
            self?.enemyAppearTimer?.invalidate()
        })
    }
    
    override func update(_ currentTime: TimeInterval) {
        for child in children {
            guard child.name == "ball", let ball = child as? Ball else { continue }
            
            ball.position = CGPoint(x: ball.position.x + ball.pixelPerFrame, y: ball.position.y)
            
            if ball.position.x - ball.r * 2 > 512 || ball.position.x + ball.r * 2 < -512 {
                ball.removeFromParent()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !isGameOver else { return }
        
        for touch in touches {
            let location = touch.location(in: self)
            
            if fireLabel.contains(location) {
                fire()
            } else if reloadLabel.contains(location) {
                reload()
            } else if location.y >= 160 {
                targetMoveBegan(location: location)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !isGameOver else { return }
        
        for touch in touches {
            let location = touch.location(in: self)
            guard location.y >= 160 else { continue }
            
            targetMoved(location: location)
        }
    }
    
    private func fire() {
        guard bullets > 0 else { return }
        
        bullets -= 1
        
        for child in children {
            guard child.name == "ball", let ball = child as? Ball else { continue }
            
            if targetNode.position.distance(to: ball.position) <= ball.r {
                let explosion = SKEmitterNode(fileNamed: "explosion")!
                explosion.position = targetNode.position
                addChild(explosion)
                score += ball.score
                ball.removeFromParent()
            }
        }
    }
    
    private func reload() {
        bullets = 6
    }
    
    private func targetMoveBegan(location: CGPoint) {
        fingerBeginPoint = location
        targetBeginPoint = targetNode.position
    }
    
    private func targetMoved(location: CGPoint) {
        let dLocation = CGPoint(x: location.x - fingerBeginPoint.x, y: location.y - fingerBeginPoint.y)
        targetNode.position = CGPoint(x: targetBeginPoint.x + dLocation.x, y: targetBeginPoint.y + dLocation.y)
    }
    
    @objc func enemyAppear() {
        let ball = Ball()
        ball.config()
        addChild(ball)
    }
}
