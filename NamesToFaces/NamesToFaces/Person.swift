//
//  Person.swift
//  NamesToFaces
//
//  Created by Ma Xueyuan on 2020/06/08.
//  Copyright © 2020 Ma Xueyuan. All rights reserved.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
