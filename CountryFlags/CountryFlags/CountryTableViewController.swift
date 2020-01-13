//
//  CountryTableViewController.swift
//  CountryFlags
//
//  Created by Ma Xueyuan on 2020/01/13.
//  Copyright © 2020 Ma Xueyuan. All rights reserved.
//

import UIKit

class CountryTableViewController: UITableViewController {
    var countries = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        countries = items.filter({
            $0.hasSuffix("@3x.png")
        })

        title = "CountryFlags"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "country", for: indexPath)

        cell.textLabel?.text = countries[indexPath.row].countryDisplayName()
        cell.imageView?.image = UIImage(named: countries[indexPath.row])
        cell.imageView?.layer.borderColor = UIColor.systemGray3.cgColor
        cell.imageView?.layer.borderWidth = 1

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = storyboard?.instantiateViewController(identifier: "detail") as! DetailViewController
        detail.country = countries[indexPath.row]
        navigationController?.pushViewController(detail, animated: true)
    }
}
