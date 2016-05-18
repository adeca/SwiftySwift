//
//  CGPoint+Extensions.swift
//  SwiftySwift
//
//  Created by Agustin De Cabrera on 5/18/16.
//  Copyright © 2016 Agustín de Cabrera. All rights reserved.
//

import CoreGraphics

// MARK: - CGPoint

extension CGPoint {
    public func pointByClamping(rect: CGRect) -> CGPoint {
        return CGPoint(
            x: clamp(x, rect.minX, rect.maxX), 
            y: clamp(y, rect.minY, rect.maxY)
        )
    }
    
    public var length: CGFloat {
        return sqrt((x * x) + (y * y))
    }
    
    public func distance(point: CGPoint) -> CGFloat {
        return sqrt(distanceSquared(point))
    }
    
    public func distanceSquared(point: CGPoint) -> CGFloat {
        return pow((x - point.x), 2) + pow((y - point.y), 2)
    }
}
