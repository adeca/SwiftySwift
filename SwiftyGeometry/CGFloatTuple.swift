//
//  CGFloatTuple.swift
//  SwiftySwift
//
//  Created by Agustin De Cabrera on 5/18/16.
//  Copyright © 2016 Agustín de Cabrera. All rights reserved.
//

import CoreGraphics

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
        return AnyGenerator([tuple.0, tuple.1].generate())
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

/// Multiply the rect's origin and size by the given value
public func * <U: CGFloatTupleConvertible>(lhs: CGRect, rhs: U) -> CGRect {
    return CGRect(origin: lhs.origin * rhs, size: lhs.size * rhs)
}
/// Multiply the rect's origin and size by the given value
public func *= <U: CGFloatTupleConvertible>(inout lhs: CGRect, rhs: U) {
    lhs = lhs * rhs
}

