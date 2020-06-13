//
//  UIButtonExt.swift
//  SwiftyWords
//
//  Created by Ma Xueyuan on 2020/06/08.
//  Copyright © 2020 Ma Xueyuan. All rights reserved.
//

import UIKit

extension UIButton {
    func drawGrayLines() {
        self.layer.borderColor = UIColor.systemBlue.cgColor
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
    }
}
