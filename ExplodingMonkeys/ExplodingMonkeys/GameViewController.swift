//
//  GameViewController.swift
//  ExplodingMonkeys
//
//  Created by Ma Xueyuan on 2020/07/25.
//  Copyright © 2020 Ma Xueyuan. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    var currentGame: GameScene?
    @IBOutlet weak var angleSlider: UISlider!
    @IBOutlet weak var velocitySlider: UISlider!
    @IBOutlet weak var angleLabel: UILabel!
    @IBOutlet weak var velocityLabel: UILabel!
    @IBOutlet weak var launchButton: UIButton!
    @IBOutlet weak var playerNumber: UILabel!
    var player1angle: Float = 45
    var player2angle: Float = 45
    var player1velocity: Float = 125
    var player2velocity: Float = 125
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        angleChanged(angleSlider!)
        velocityChanged(velocitySlider!)
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
                
                currentGame = scene as? GameScene
                currentGame?.viewController = self
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func angleChanged(_ sender: Any) {
        angleLabel.text = "Angle: \(Int(angleSlider.value))°"
    }
    
    @IBAction func velocityChanged(_ sender: Any) {
        velocityLabel.text = "Velocity: \(Int(velocitySlider.value))"
    }
    
    @IBAction func launch(_ sender: Any) {
        angleSlider.isHidden = true
        angleLabel.isHidden = true

        velocitySlider.isHidden = true
        velocityLabel.isHidden = true

        launchButton.isHidden = true
        
        guard let currentPlayer = currentGame?.currentPlayer else { fatalError("no current game!") }
        if currentPlayer == 1 {
            player1angle = angleSlider.value
            player1velocity = velocitySlider.value
        } else {
            player2angle = angleSlider.value
            player2velocity = velocitySlider.value
        }

        currentGame?.launch(angle: Int(angleSlider.value), velocity: Int(velocitySlider.value))
    }
    
    func activatePlayer(number: Int) {
        if number == 1 {
            playerNumber.text = "<<< PLAYER ONE"
            angleSlider.setValue(player1angle, animated: false)
            velocitySlider.setValue(player1velocity, animated: false)
        } else {
            playerNumber.text = "PLAYER TWO >>>"
            angleSlider.setValue(player2angle, animated: false)
            velocitySlider.setValue(player2velocity, animated: false)
        }
        angleChanged(angleSlider!)
        velocityChanged(velocitySlider!)

        angleSlider.isHidden = false
        angleLabel.isHidden = false

        velocitySlider.isHidden = false
        velocityLabel.isHidden = false

        launchButton.isHidden = false
    }
}
