//
//  FinalScoreViewController.swift
//  GuessTheFlag
//
//  Created by Ma Xueyuan on 2020/01/09.
//  Copyright © 2020 Ma Xueyuan. All rights reserved.
//

import UIKit

class FinalScoreViewController: UIViewController {
    @IBOutlet var finalScoreLabel: UILabel!
    var finalScore: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        let historyHigh = UserDefaults.standard.integer(forKey: "high")
        var message = "Your final score is \(finalScore!).\n"
        if finalScore > historyHigh {
            message.append("You break the history!!!")
            UserDefaults.standard.set(finalScore!, forKey: "high")
        } else {
            message.append("History high is \(historyHigh)")
        }
        
        finalScoreLabel.text = message
    }
    
    @objc func shareTapped() {
        let vc = UIActivityViewController(activityItems: ["I got \(finalScore!) points in Guess the Flag. Try it now!"], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
