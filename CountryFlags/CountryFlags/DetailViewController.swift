//
//  DetailViewController.swift
//  CountryFlags
//
//  Created by Ma Xueyuan on 2020/01/13.
//  Copyright © 2020 Ma Xueyuan. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var country: String!
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        title = country.countryDisplayName()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        imageView.image = UIImage(named: country!)
        imageView.layer.borderColor = UIColor.systemGray3.cgColor
        imageView.layer.borderWidth = 2
    }
    
    @objc func shareTapped() {
        let avc = UIActivityViewController(activityItems: [country.countryDisplayName(), imageView.image!], applicationActivities: [])
        avc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(avc, animated: true)
    }
}

