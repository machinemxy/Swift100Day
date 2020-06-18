//
//  Capital.swift
//  CapitalCities
//
//  Created by Ma Xueyuan on 2020/06/18.
//  Copyright © 2020 Ma Xueyuan. All rights reserved.
//

import UIKit
import MapKit

class Capital: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var url: String
    
    init(title: String, coordinate: CLLocationCoordinate2D, url: String) {
        self.title = title
        self.coordinate = coordinate
        self.url = url
    }
}
