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
    var searchController: UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()

        getList()
        
        // configure data source
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { [unowned self] (tableView, indexPath, memo) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifier, for: indexPath)
            cell.textLabel?.text = memo.title
            
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            cell.detailTextLabel?.text = formatter.string(from: memo.editTime) + " " + memo.detail
            
            return cell
        })
        
        // configure search controller
        searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        
        // configure add button
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMemo))
        
        updateTable()
    }
    
    func getList() {
        let documentDirectory = FileManager.default.getDocumentsDirectory()
        let decoder = JSONDecoder()
        do {
            let memoURLs = try FileManager.default.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            for memoURL in memoURLs {
                let data = try Data(contentsOf: memoURL)
                let memo = try decoder.decode(Memo.self, from: data)
                list.append(memo)
            }
        } catch {
            print(error.localizedDescription)
        }
        
        list.sort { $0.editTime > $1.editTime }
    }
    
    func updateTable() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Memo>()
        snapshot.appendSections([.main])
        
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            snapshot.appendItems(list, toSection: .main)
            dataSource.apply(snapshot)
            return
        }
        
        let lowerCasedFilter = filter.lowercased()
        let filteredList = list.filter { (memo) -> Bool in
            memo.title.lowercased().contains(lowerCasedFilter) || memo.detail.contains(lowerCasedFilter)
        }
        
        snapshot.appendItems(filteredList, toSection: .main)
        dataSource.apply(snapshot)
    }
    
    @objc func addMemo() {
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "detail") as! MemoDetailViewController
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let memo = dataSource.itemIdentifier(for: indexPath) else { return }
        
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "detail") as! MemoDetailViewController
        detailVC.memo = memo
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    @IBAction func didUnwindFromDetailView(segue: UIStoryboardSegue) {
        let sourceVC = segue.source as! MemoDetailViewController
        guard let memo = sourceVC.memo else { return }
        guard let reason = sourceVC.rewindReason else { return }
        
        switch reason {
        case .delete:
            list.removeAll { $0.id == memo.id }
        case .save:
            list.removeAll { $0.id == memo.id }
            list.insert(memo, at: 0)
        }
        
        updateTable()
    }
}

extension MemoListTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        updateTable()
    }
}
