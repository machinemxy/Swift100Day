//
//  Petition.swift
//  WhiteHousePetitions
//
//  Created by Ma Xueyuan on 2020/06/04.
//  Copyright © 2020 Ma Xueyuan. All rights reserved.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
