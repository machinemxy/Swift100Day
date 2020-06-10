//
//  DetailViewController.swift
//  NamesToFaces
//
//  Created by Ma Xueyuan on 2020/06/11.
//  Copyright © 2020 Ma Xueyuan. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    var person: Person!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = person.name
        imageView.image = FileManager.default.getImageInDocumentsDirectory(imageName: person.image)
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
