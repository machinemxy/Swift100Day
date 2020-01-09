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

        if let finalScore = finalScore {
            finalScoreLabel.text = "Your final score is \(finalScore)."
        }
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
