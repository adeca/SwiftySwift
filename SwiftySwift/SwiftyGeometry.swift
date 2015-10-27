//
//  SwiftyGeometry.swift
//  SwiftySwift
//
//  Created by Agustín de Cabrera on 10/27/15.
//  Copyright © 2015 Agustín de Cabrera. All rights reserved.
//

import UIKit
import CoreGraphics

// MARK: - UIGeometry

extension UIEdgeInsets {
    public var topLeft: CGPoint { 
        return CGPoint(x: left, y: top) 
    }
    public var bottomRight: CGPoint {
        return CGPoint(x: right, y: bottom) 
    }
    
    public static var zero = UIEdgeInsetsZero
}

// MARK: - CGGeometry

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

extension CGRect {
    public init(_ values: (CGFloat, CGFloat, CGFloat, CGFloat)) {
        self.init(x: values.0, y: values.1, width: values.2, height: values.3)
    }
    
    public func rectByClamping(rect: CGRect) -> CGRect {
        if size.width > rect.size.width || size.height > rect.size.height {
            return CGRect.null
        }
        
        let newRect = CGRect(origin: rect.origin, size: rect.size - size)
        let newOrigin = origin.pointByClamping(newRect)
        
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
}

/// Interpolate between two rects
public func lerp(from: CGRect, _ to: CGRect, _ progress: Double) -> CGRect {
    let progress = CGFloat(progress)
    return CGRect(
        x: lerp(from.origin.x, to.origin.x, progress),
        y: lerp(from.origin.y, to.origin.y, progress),
        width:  lerp(from.size.width,  to.size.width,  progress),
        height: lerp(from.size.height, to.size.height, progress)
    )
}

/// Add the given point to the rect's origin
public func + (lhs: CGRect, rhs: CGPoint) -> CGRect {
    return CGRect(origin: lhs.origin + rhs, size: lhs.size)
}
/// Add the given vector to the rect's origin
public func + (lhs: CGRect, rhs: CGVector) -> CGRect {
    return lhs + CGPoint(rhs)
}
/// Add the given size to the rect's size
public func + (lhs: CGRect, rhs: CGSize) -> CGRect {
    return CGRect(origin: lhs.origin, size: lhs.size + rhs)
}

/// Substract the given point to the rect's origin
public func - (lhs: CGRect, rhs: CGPoint) -> CGRect {
    return CGRect(origin: lhs.origin - rhs, size: lhs.size)
}
/// Substract the given vector to the rect's origin
public func - (lhs: CGRect, rhs: CGVector) -> CGRect {
    return lhs - CGPoint(rhs)
}
/// Substract the given size to the rect's size
public func - (lhs: CGRect, rhs: CGSize) -> CGRect {
    return CGRect(origin: lhs.origin, size: lhs.size - rhs)
}

/// Multiply the rect's origin and size by the given value
public func * <U: CGFloatTupleConvertible>(lhs: CGRect, rhs: U) -> CGRect {
    return CGRect(origin: lhs.origin * rhs, size: lhs.size * rhs)
}
/// Multiply the rect's origin and size by the given value
public func *= <U: CGFloatTupleConvertible>(inout lhs: CGRect, rhs: U) {
    lhs = lhs * rhs
}
/// Multiply the rect's origin and size by the given value
public func * (lhs: CGRect, rhs: CGFloat) -> CGRect {
    return CGRect(origin: lhs.origin * rhs, size: lhs.size * rhs)
}
/// Multiply the rect's origin and size by the given value
public func *= (inout lhs: CGRect, rhs: CGFloat) {
    lhs = lhs * rhs
}

// MARK: - CGFloatTuple

/// Type that can be serialized to a pair of CGFloat values
public typealias CGFloatTuple = (CGFloat, CGFloat)
public protocol CGFloatTupleConvertible {    
    var tuple: CGFloatTuple { get }
    init(tuple: CGFloatTuple)
    
    // methods with default implementations
    init(_ other: CGFloatTupleConvertible)
}

extension CGFloatTupleConvertible {
    public init(_ other: CGFloatTupleConvertible) {
        self.init(tuple: other.tuple)
    }
    
    public func generate() -> AnyGenerator<CGFloat> {
        return anyGenerator([tuple.0, tuple.1].generate())
    }
    
    public func minElement() -> CGFloat {
        return min(self.tuple)
    }
    
    public func maxElement() -> CGFloat {
        return max(self.tuple)
    }
}

public func max(x: CGFloatTupleConvertible) -> CGFloat {
    return x.maxElement()
}

public func min(x: CGFloatTupleConvertible) -> CGFloat {
    return x.minElement()
}

/// Functional methods used to apply transforms to a pair of floats
extension CGFloatTupleConvertible {
    public func map(@noescape transform: CGFloat -> CGFloat) -> Self {
        let t = self.tuple
        let result = (transform(t.0), transform(t.1))
        return Self(tuple: result)
    }
    
    public func merge<T: CGFloatTupleConvertible>(rhs: T, @noescape _ transform: CGFloatTuple -> CGFloat) -> Self {
        let (t0, t1) = (self.tuple, rhs.tuple)
        let result = (transform(t0.0, t1.0), transform(t0.1, t1.1))
        return Self(tuple: result)
    }
    
    public func merge<T: CGFloatTupleConvertible, U: CGFloatTupleConvertible>(a: T, _ b: U, @noescape _ transform: (CGFloat, CGFloat, CGFloat) -> CGFloat) -> Self {
        let (t0, t1, t2) = (self.tuple, a.tuple, b.tuple)
        let result = (transform(t0.0, t1.0, t2.0), transform(t0.1, t1.1, t2.1))
        return Self(tuple: result)
    }
}

/// Operators that can be applied to a pair of CGFloatTupleConvertible objects
/// Each operation will work on an element-by-element basis

public func + <T: CGFloatTupleConvertible>(lhs: T, rhs: T) -> T {
    return lhs.merge(rhs, +)
}
public func += <T: CGFloatTupleConvertible>(inout lhs: T, rhs: T) {
    lhs = lhs + rhs
}

public func - <T: CGFloatTupleConvertible>(lhs: T, rhs: T) -> T {
    return lhs.merge(rhs, -)
}
public func -= <T: CGFloatTupleConvertible>(inout lhs: T, rhs: T) {
    lhs = lhs - rhs
}

public func * <T: CGFloatTupleConvertible>(lhs: T, rhs: CGFloat) -> T {
    return lhs.map { $0 * rhs }
}
public func *= <T: CGFloatTupleConvertible>(inout lhs: T, rhs: CGFloat) {
    lhs = lhs * rhs
}

public func / <T: CGFloatTupleConvertible>(lhs: T, rhs: CGFloat) -> T {
    return lhs.map { $0 / rhs }
}
public func /= <T: CGFloatTupleConvertible>(inout lhs: T, rhs: CGFloat) {
    lhs = lhs / rhs
}

public func * <T: CGFloatTupleConvertible, U: CGFloatTupleConvertible>(lhs: T, rhs: U) -> T {
    return lhs.merge(rhs, *)
}
public func *= <T: CGFloatTupleConvertible, U: CGFloatTupleConvertible>(inout lhs: T, rhs: U) {
    lhs = lhs * rhs
}

public func / <T: CGFloatTupleConvertible, U: CGFloatTupleConvertible>(lhs: T, rhs: U) -> T {
    return lhs.merge(rhs, /)
}
public func /= <T: CGFloatTupleConvertible, U: CGFloatTupleConvertible>(inout lhs: T, rhs: U) {
    lhs = lhs / rhs
}

public func + <T: CGFloatTupleConvertible, U: CGFloatTupleConvertible>(lhs: T, rhs: U) -> T {
    return lhs.merge(rhs, +)
}
public func += <T: CGFloatTupleConvertible, U: CGFloatTupleConvertible>(inout lhs: T, rhs: U) {
    lhs = lhs + rhs
}

public func - <T: CGFloatTupleConvertible, U: CGFloatTupleConvertible>(lhs: T, rhs: U) -> T {
    return lhs.merge(rhs, -)
}
public func -= <T: CGFloatTupleConvertible, U: CGFloatTupleConvertible>(inout lhs: T, rhs: U) {
    lhs = lhs - rhs
}

public prefix func + <T: CGFloatTupleConvertible>(rhs: T) -> T {
    return rhs
}
public prefix func - <T: CGFloatTupleConvertible>(rhs: T) -> T {
    return rhs.map { -$0 }
}

public func abs<T: CGFloatTupleConvertible>(x: T) -> T {
    return x.map { abs($0) }
}

public func clamp<T: CGFloatTupleConvertible, U: CGFloatTupleConvertible, V: CGFloatTupleConvertible>(x: T, _ low: U, _ high: V) -> T {
    return x.merge(low, high, clamp)
}

/// CGPoint, CGVector and CGSize can be converted to a pair of floats.
/// Conforming to CGFloatTupleConvertible allows using the operators defined above. 

extension CGPoint: CGFloatTupleConvertible {
    public var tuple: CGFloatTuple { return (x, y) }
    
    public init(tuple: CGFloatTuple) {
        self.init(x: tuple.0, y: tuple.1)
    }
}

extension CGSize: CGFloatTupleConvertible {    
    public var tuple: CGFloatTuple { return (width, height) }
    
    public init(tuple: CGFloatTuple) {
        self.init(width: tuple.0, height: tuple.1)
    }
}

extension CGVector: CGFloatTupleConvertible {
    public var tuple: CGFloatTuple { return (dx, dy) }
    
    public init(tuple: CGFloatTuple) {
        self.init(dx: tuple.0, dy: tuple.1)
    }
}
