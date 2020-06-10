//
//  ViewController.swift
//  Words
//
//  Created by Ma Xueyuan on 2020/05/26.
//  Copyright © 2020 Ma Xueyuan. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var allWords = [String]()
    var userdWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
        if let storedTitle = UserDefaults.standard.string(forKey: Key.title), !storedTitle.isEmpty {
            title = storedTitle
            if let storedList = UserDefaults.standard.object(forKey: Key.list) as? [String] {
                userdWords = storedList
            }
        } else {
            startGame()
        }
    }

    @objc func startGame() {
        title = allWords.randomElement()
        userdWords.removeAll(keepingCapacity: true)
        
        // save
        UserDefaults.standard.set(title!, forKey: Key.title)
        UserDefaults.standard.set(userdWords, forKey: Key.list)
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userdWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = userdWords[indexPath.row]
        return cell
    }
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        
        guard isOriginal(word: lowerAnswer) else {
            alert(title: "Word already used", message: "Be more original!")
            return
        }
        
        guard isLongEnough(word: lowerAnswer, minLength: 3) else {
            alert(title: "Word not long enough", message: "It should be at least 3 letters.")
            return
        }
        
        guard isDiffrentWithOriginWord(word: lowerAnswer) else {
            alert(title: "Word illegal", message: "You cannot input the original word.")
            return
        }
        
        guard isPossible(word: lowerAnswer) else {
            alert(title: "Word not possible", message: "You can't spell that word from \(title!.lowercased())")
            return
        }
        
        guard isReal(word: lowerAnswer) else {
            alert(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }
        
        userdWords.insert(lowerAnswer, at: 0)
        UserDefaults.standard.set(userdWords, forKey: Key.list)
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }
    
    func isOriginal(word: String) -> Bool {
        return !userdWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = title!.lowercased()
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    func isDiffrentWithOriginWord(word: String) -> Bool {
        word != title!.lowercased()
    }
    
    func isLongEnough(word: String, minLength: Int) -> Bool {
        word.count >= minLength
    }
    
    func alert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true)
    }
}

