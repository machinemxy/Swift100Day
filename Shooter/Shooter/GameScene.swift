//
//  GameScene.swift
//  Shooter
//
//  Created by Ma Xueyuan on 2020/06/22.
//  Copyright © 2020 Ma Xueyuan. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    let timeLimit = 60.0
    let interval = 0.35
    
    var bulletNodes = [SKNode]()
    var fireLabel: SKNode!
    var reloadLabel: SKNode!
    var gameOverLabel: SKNode!
    var scoreLabel: SKLabelNode!
    var targetNode: SKNode!
    
    var gameOverTimer: Timer?
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
        
        // start the game over timer
        gameOverTimer = Timer.scheduledTimer(withTimeInterval: timeLimit, repeats: false, block: { [weak self] (_) in
            self?.isGameOver = true
        })
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
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    private func fire() {
        guard bullets > 0 else { return }
        
        bullets -= 1
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
}
