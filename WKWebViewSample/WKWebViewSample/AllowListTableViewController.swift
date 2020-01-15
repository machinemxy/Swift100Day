//
//  AllowListTableViewController.swift
//  WKWebViewSample
//
//  Created by Ma Xueyuan on 2020/01/15.
//  Copyright © 2020 Ma Xueyuan. All rights reserved.
//

import UIKit

class AllowListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "WKWebViewSample"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WebSite.allowList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = WebSite.allowList[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = storyboard?.instantiateViewController(identifier: "webView") as! ViewController
        viewController.firstURL = WebSite.allowList[indexPath.row]
        navigationController?.pushViewController(viewController, animated: true)
    }
}
