//
//  ShoppingTableViewController.swift
//  ShoppingList
//
//  Created by Ma Xueyuan on 2020/06/04.
//  Copyright © 2020 Ma Xueyuan. All rights reserved.
//

import UIKit

class ShoppingTableViewController: UITableViewController {
    var shoppingList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Shopping List"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(clear))
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insert)),
            UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share)),
        ]
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return shoppingList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shopping", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = shoppingList[indexPath.row]

        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {
            return
        }
        
        shoppingList.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    @objc func clear() {
        shoppingList.removeAll()
        tableView.reloadData()
    }
    
    @objc func insert() {
        let ac = UIAlertController(title: "Things you want to buy", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let confirm = UIAlertAction(title: "Confirm", style: .default) { [weak ac, weak self] (_) in
            if let text = ac?.textFields?.first?.text, !text.isEmpty {
                self?.shoppingList.insert(text, at: 0)
                self?.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            }
        }
        ac.addAction(confirm)
        present(ac, animated: true)
    }
    
    @objc func share() {
        let avc = UIActivityViewController(activityItems: [shoppingList.joined(separator: "\n")], applicationActivities: nil)
        avc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItems?[1]
        present(avc, animated: true)
    }
}
