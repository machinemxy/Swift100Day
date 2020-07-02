//
//  MemoListTableViewController.swift
//  MemoNote
//
//  Created by Ma Xueyuan on 2020/07/02.
//  Copyright © 2020 Ma Xueyuan. All rights reserved.
//

import UIKit

class MemoListTableViewController: UITableViewController {
    enum Section {
        case main
    }
    
    let cellReuseIdentifier = "memo"
    
    var list = [Memo]()
    var dataSource: UITableViewDiffableDataSource<Section, Memo>!

    override func viewDidLoad() {
        super.viewDidLoad()

        // debug data
        for i in 1...10 {
            var memo = Memo()
            memo.title = "Memo\(i)"
            memo.detail = "南无阿弥陀佛南无阿弥陀佛南无阿弥陀佛南无阿弥陀佛南无阿弥陀佛南无阿弥陀佛南无阿弥陀佛南无阿弥陀佛南无阿弥陀佛"
            list.append(memo)
        }
        
        // configure data source
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { [unowned self] (tableView, indexPath, memo) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifier, for: indexPath)
            cell.textLabel?.text = memo.title
            
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            cell.detailTextLabel?.text = formatter.string(from: memo.editTime) + " " + memo.detail
            
            return cell
        })
        
        update(with: list)
        
        // configure search controller
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    func update(with list: [Memo]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Memo>()
        snapshot.appendSections([.main])
        snapshot.appendItems(list, toSection: .main)
        dataSource.apply(snapshot)
    }
}

extension MemoListTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            update(with: list)
            return
        }
        
        let lowerCasedFilter = filter.lowercased()
        let filteredList = list.filter { (memo) -> Bool in
            memo.title.lowercased().contains(lowerCasedFilter) || memo.detail.contains(lowerCasedFilter)
        }
        
        update(with: filteredList)
    }
}
