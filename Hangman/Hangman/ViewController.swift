//
//  ViewController.swift
//  Hangman
//
//  Created by Ma Xueyuan on 2020/06/08.
//  Copyright © 2020 Ma Xueyuan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var txtAnswer: UITextField!
    @IBOutlet weak var hpBar: UIProgressView!
    @IBOutlet weak var lblTriedLetters: UITextView!
    
    var allQuestions: [String]!
    var currentQuestion: String!
    
    var score = 0 {
        didSet {
            lblScore.text = "Score: \(score)"
        }
    }
    
    var hp = 10 {
        didSet {
            hpBar.setProgress(Float(hp) / Float(10), animated: true)
        }
    }
    
    var storedAnswers = [Character]() {
        didSet {
            // set lblQuestion
            var displayAnswer = ""
            for char in currentQuestion {
                if storedAnswers.contains(char) {
                    displayAnswer.append(char)
                } else {
                    displayAnswer.append("?")
                }
            }
            lblQuestion.text = displayAnswer
            
            // set lblTriedLetters
            var triedLetters = "Tried letters:\n"
            let storedAnswersString = storedAnswers.map { (c) -> String in
                String(c)
            }
            triedLetters.append(storedAnswersString.joined(separator: " "))
            lblTriedLetters.text = triedLetters
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load words
        guard let url = Bundle.main.url(forResource: "Words", withExtension: "txt") else { fatalError("load words failed") }
        guard let allQuestionsString = try? String(contentsOf: url) else { fatalError("load words failed") }
        allQuestions = allQuestionsString.components(separatedBy: "\n")
        setGame()
    }

    @IBAction func guess(_ sender: Any) {
        guard let input = txtAnswer.text, !input.isEmpty else {
            alertError(message: "Please enter a letter.")
            return
        }
        
        guard input.count == 1, let char = input.lowercased().first else {
            alertError(message: "Please don't input more than one letter.")
            return
        }
        
        guard !storedAnswers.contains(char) else {
            alertError(message: "You already tried this letter.")
            return
        }
        
        storedAnswers.append(char)
        txtAnswer.text = ""
        
        if currentQuestion.contains(char) {
            // good guess
            guard let displayAnswer = lblQuestion.text else { fatalError("cannot access to lblQuestion") }
            if !displayAnswer.contains("?") {
                score += 1
                let ac = UIAlertController(title: "You Win", message: "The answer is \(currentQuestion!).", preferredStyle: .alert)
                let nextGame = UIAlertAction(title: "Next Game", style: .default) { [unowned self] _ in
                    self.setGame()
                }
                ac.addAction(nextGame)
                present(ac, animated: true)
            }
        } else {
            // bad guess
            hp -= 1
            if hp == 0 {
                let ac = UIAlertController(title: "You Died", message: "Your final score: \(score)", preferredStyle: .alert)
                let restart = UIAlertAction(title: "Restart", style: .default) { [unowned self] _ in
                    self.score = 0
                    self.setGame()
                }
                ac.addAction(restart)
                present(ac, animated: true)
            }
        }
    }
    
    private func setGame() {
        hp = 10
        let randInt = Int.random(in: 0..<allQuestions.count)
        currentQuestion = allQuestions[randInt]
        storedAnswers.removeAll()
    }
    
    private func alertError(message: String) {
        let ac = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(ac, animated: true)
    }
}

