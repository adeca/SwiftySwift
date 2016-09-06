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
    public func clamped(to rect: CGRect) -> CGPoint {
        return CGPoint(
            x: clamp(x, rect.minX, rect.maxX), 
            y: clamp(y, rect.minY, rect.maxY)
        )
    }
    
    public var length: CGFloat {
        return sqrt((x * x) + (y * y))
    }
    
    public func distance(to point: CGPoint) -> CGFloat {
        return sqrt(distanceSquared(to: point))
    }
    
    public func distanceSquared(to point: CGPoint) -> CGFloat {
        return ((x - point.x) * (x - point.x)) + 
            ((y - point.y) * (y - point.y))
    }
}
