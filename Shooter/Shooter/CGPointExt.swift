//
//  CGPointExt.swift
//  Shooter
//
//  Created by Ma Xueyuan on 2020/06/24.
//  Copyright © 2020 Ma Xueyuan. All rights reserved.
//

import SpriteKit

extension CGPoint {
    func distance(to anotherCGPoint: CGPoint) -> CGFloat {
        let xDist = self.x - anotherCGPoint.x
        let yDist = self.y - anotherCGPoint.y
        return sqrt(xDist * xDist) + sqrt(yDist * yDist)
    }
}
