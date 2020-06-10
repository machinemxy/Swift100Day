//
//  Person.swift
//  NamesToFaces
//
//  Created by Ma Xueyuan on 2020/06/08.
//  Copyright © 2020 Ma Xueyuan. All rights reserved.
//

import UIKit

class Person: NSObject, NSCoding {
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(image, forKey: "image")
    }
    
    required init?(coder: NSCoder) {
        name = coder.decodeObject(forKey: "name") as! String
        image = coder.decodeObject(forKey: "image") as! String
    }
    
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
