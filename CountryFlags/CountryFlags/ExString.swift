//
//  ExString.swift
//  CountryFlags
//
//  Created by Ma Xueyuan on 2020/01/13.
//  Copyright © 2020 Ma Xueyuan. All rights reserved.
//

import Foundation

extension String {
    func countryDisplayName() -> String {
        return self.replacingOccurrences(of: "@3x.png", with: "").uppercased()
    }
}
