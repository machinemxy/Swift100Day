//
//  GameScene.swift
//  Shooter
//
//  Created by Ma Xueyuan on 2020/06/22.
//  Copyright © 2020 Ma Xueyuan. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var bulletNodes = [SKNode]()
    var fireLabel: SKNode!
    var reloadLabel: SKNode!
    
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
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if fireLabel.contains(location) {
                fire()
            } else if reloadLabel.contains(location) {
                reload()
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
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
}
