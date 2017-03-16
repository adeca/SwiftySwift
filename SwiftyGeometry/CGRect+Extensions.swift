//
//  CGRect+Extensions.swift
//  SwiftySwift
//
//  Created by Agustin De Cabrera on 5/18/16.
//  Copyright © 2016 Agustín de Cabrera. All rights reserved.
//

import CoreGraphics

// MARK: - CGRect

extension CGRect {
    public init(_ values: (CGFloat, CGFloat, CGFloat, CGFloat)) {
        self.init(x: values.0, y: values.1, width: values.2, height: values.3)
    }
    
    public func clamped(to rect: CGRect) -> CGRect {
        if size.width > rect.size.width || size.height > rect.size.height {
            return CGRect.null
        }
        
        let newRect = CGRect(origin: rect.origin, size: rect.size - size)
        let newOrigin = origin.clamped(to: newRect)
        
        return CGRect(origin: newOrigin, size: size)
    }
    
    public init(origin: CGPoint, width: CGFloat, height: CGFloat) {
        self.init(x: origin.x, y: origin.y, width: width, height: height)
    }
    
    public init(x: CGFloat, y: CGFloat, size: CGSize) {
        self.init(x: x, y: y, width: size.width, height: size.height)
    }
    
    public var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
    
    /// Add the given point to the rect's origin
    public static func + (lhs: CGRect, rhs: CGPoint) -> CGRect {
        return CGRect(origin: lhs.origin + rhs, size: lhs.size)
    }
    /// Add the given vector to the rect's origin
    public static func + (lhs: CGRect, rhs: CGVector) -> CGRect {
        return lhs + CGPoint(rhs)
    }
    /// Add the given size to the rect's size
    public static func + (lhs: CGRect, rhs: CGSize) -> CGRect {
        return CGRect(origin: lhs.origin, size: lhs.size + rhs)
    }
    
    /// Substract the given point to the rect's origin
    public static func - (lhs: CGRect, rhs: CGPoint) -> CGRect {
        return CGRect(origin: lhs.origin - rhs, size: lhs.size)
    }
    /// Substract the given vector to the rect's origin
    public static func - (lhs: CGRect, rhs: CGVector) -> CGRect {
        return lhs - CGPoint(rhs)
    }
    /// Substract the given size to the rect's size
    public static func - (lhs: CGRect, rhs: CGSize) -> CGRect {
        return CGRect(origin: lhs.origin, size: lhs.size - rhs)
    }
    
    /// Multiply the rect's origin and size by the given value
    public static func * (lhs: CGRect, rhs: CGFloat) -> CGRect {
        return CGRect(origin: lhs.origin * rhs, size: lhs.size * rhs)
    }
    /// Multiply the rect's origin and size by the given value
    public static func *= (lhs: inout CGRect, rhs: CGFloat) {
        lhs = lhs * rhs
    }
}

/// Interpolate between two rects
public func lerp(_ from: CGRect, _ to: CGRect, _ progress: Double) -> CGRect {
    let progress = CGFloat(progress)
    return CGRect(
        x: lerp(from.origin.x, to.origin.x, progress),
        y: lerp(from.origin.y, to.origin.y, progress),
        width:  lerp(from.size.width,  to.size.width,  progress),
        height: lerp(from.size.height, to.size.height, progress)
    )
}
