//
//  ViewController.swift
//  WhiteHousePetitions
//
//  Created by Ma Xueyuan on 2020/06/04.
//  Copyright © 2020 Ma Xueyuan. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    var isSearching = false
    var urlString: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // fetch data
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }

        DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
            guard let url = URL(string: self.urlString) else {
                self.showError()
                return
            }
            
            guard let data = try? Data(contentsOf: url) else {
                self.showError()
                return
            }
            
            self.parse(json: data)
        }
        
        // configure right button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credit", style: .plain, target: self, action: #selector(showCredit))
        
        // configure search bar
        let sc = UISearchController()
        sc.searchResultsUpdater = self
        sc.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = sc
    }
    
    @objc func showCredit() {
        let ac = UIAlertController(title: "Credit", message: urlString, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true)
    }
    
    func showError() {
        DispatchQueue.main.async { [unowned self] in
            let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(ac, animated: true)
        }
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            DispatchQueue.main.async { [unowned self] in
                self.tableView.reloadData()
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredPetitions.count
        } else {
            return petitions.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let petition: Petition
        if isSearching {
            petition = filteredPetitions[indexPath.row]
        } else {
            petition = petitions[indexPath.row]
        }
        
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            filteredPetitions.removeAll()
            isSearching = false
            tableView.reloadData()
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
            self.isSearching = true
            let lowCaseFilter = filter.lowercased()
            self.filteredPetitions = self.petitions.filter({ (p) -> Bool in
                p.title.lowercased().contains(lowCaseFilter)
            })
            
            DispatchQueue.main.async { [unowned self] in
                self.tableView.reloadData()
            }
        }
    }
}

