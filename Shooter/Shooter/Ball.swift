//
//  Ball.swift
//  Shooter
//
//  Created by Ma Xueyuan on 2020/06/24.
//  Copyright © 2020 Ma Xueyuan. All rights reserved.
//

import SpriteKit

class Ball: SKSpriteNode {
    static let speeds = [1, 2, 1]
    static let moveDirections = [1, -1, 1]
    
    var type: Int!
    var line: Int!
    var ballSpeed: CGFloat!
    
    var ballTexture: String {
        switch type {
        case 0:
            return "ballYellow"
        case 1:
            return "ballRed"
        default:
            return "ballGreen"
        }
    }
    
    var r: CGFloat {
        if type == 1 {
            return 22
        } else {
            return 44
        }
    }
    
    var score: Int {
        switch type {
        case 0:
            return 1
        case 1:
            return 3
        default:
            return -5
        }
    }
    
    var pixelPerFrame: CGFloat {
        let direction: CGFloat
        if line == 1 {
            direction = -1
        } else {
            direction = 1
        }
        
        if type == 1 {
            return direction * ballSpeed * 2
        } else {
            return direction * ballSpeed
        }
    }
    
    func config() {
        name = "ball"
        type = Int.random(in: 0...2)
        texture = SKTexture(imageNamed: ballTexture)
        size = CGSize(width: r * 2, height: r * 2)
        
        line = Int.random(in: 0...2)
        if line == 1 {
            position = CGPoint(x: 512 + r, y: 320 + 160 * CGFloat(line))
        } else {
            position = CGPoint(x: -512 - r, y: 320 + 160 * CGFloat(line))
        }
        
        ballSpeed = CGFloat.random(in: 2...4)
    }
}
