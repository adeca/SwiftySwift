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
    init<T: CGFloatTupleConvertible>(_ other: T)
}

extension CGFloatTupleConvertible {
    public init<T: CGFloatTupleConvertible>(_ other: T) {
        self.init(tuple: other.tuple)
    }
    
    public func makeIterator() -> AnyIterator<CGFloat> {
        return AnyIterator([tuple.0, tuple.1].makeIterator())
    }
    
    public func max() -> CGFloat {
        return Swift.max(tuple.0, tuple.1)
    }
    
    public func min() -> CGFloat {
        return Swift.min(tuple.0, tuple.1)
    }
}

/// Functional methods used to apply transforms to a pair of floats
extension CGFloatTupleConvertible {
    public func map(_ transform: (CGFloat) throws -> CGFloat) rethrows -> Self {
        let t = self.tuple
        let result = (try transform(t.0), 
                      try transform(t.1))
        return Self(tuple: result)
    }
    
    public func merge(_ other: CGFloatTupleConvertible, _ transform: (CGFloat, CGFloat) throws -> CGFloat) rethrows -> Self {
        let (t0, t1) = (self.tuple, other.tuple)
        let result = (try transform(t0.0, t1.0), 
                      try transform(t0.1, t1.1))
        return Self(tuple: result)
    }
    
    public func merge(_ others: [CGFloatTupleConvertible], _ transform: ([CGFloat]) throws -> CGFloat) rethrows -> Self {
        let tuples = [self.tuple] + others.map { $0.tuple }
        let result = (try transform(tuples.map { $0.0 }), 
                      try transform(tuples.map { $0.1 }))
        return Self(tuple: result)
    }
}

/// Operators that can be applied to a pair of CGFloatTupleConvertible objects
/// Each operation will work on an element-by-element basis

extension CGFloatTupleConvertible {
    public static func +<T: CGFloatTupleConvertible>(lhs: Self, rhs: T) -> Self {
        return lhs.merge(rhs, +)
    }
    public static func +=<T: CGFloatTupleConvertible>(lhs: inout Self, rhs: T) {
        lhs = lhs + rhs
    }

    public static func -<T: CGFloatTupleConvertible>(lhs: Self, rhs: T) -> Self {
        return lhs.merge(rhs, -)
    }
    public static func -=<T: CGFloatTupleConvertible>(lhs: inout Self, rhs: T) {
        lhs = lhs - rhs
    }
    
    public static func - (lhs: Self, rhs: CGFloat) -> Self {
        return lhs.map({ $0 - rhs })
    }
    public static func -= (lhs: inout Self, rhs: CGFloat) {
        lhs = lhs - rhs
    }
    
    public static func *(lhs: Self, rhs: CGFloat) -> Self {
        return lhs.map { $0 * rhs }
    }
    public static func *=(lhs: inout Self, rhs: CGFloat) {
        lhs = lhs * rhs
    }
    
    public static func /(lhs: Self, rhs: CGFloat) -> Self {
        return lhs.map { $0 / rhs }
    }
    public static func /=(lhs: inout Self, rhs: CGFloat) {
        lhs = lhs / rhs
    }
    
    public static func *<T: CGFloatTupleConvertible>(lhs: Self, rhs: T) -> Self {
        return lhs.merge(rhs, *)
    }
    public static func *=<T: CGFloatTupleConvertible>(lhs: inout Self, rhs: T) {
        lhs = lhs * rhs
    }
    
    public static func /<T: CGFloatTupleConvertible>(lhs: Self, rhs: T) -> Self {
        return lhs.merge(rhs, /)
    }
    public static func /=<T: CGFloatTupleConvertible>(lhs: inout Self, rhs: T) {
        lhs = lhs / rhs
    }
    
    public static prefix func -(rhs: Self) -> Self {
        return rhs.map { -$0 }
    }
}

public func abs<T: CGFloatTupleConvertible>(_ x: T) -> T {
    return x.map { abs($0) }
}

public func clamp<T: CGFloatTupleConvertible>(_ x: T, min: CGFloatTupleConvertible, max: CGFloatTupleConvertible) -> T {
    return x.merge([min, max]) {
        clamp($0[0], min: $0[1], max: $0[2])
    }
}

@available(*, deprecated)
public func clamp<T: CGFloatTupleConvertible>(_ x: T, _ min: CGFloatTupleConvertible, _ max: CGFloatTupleConvertible) -> T {
    return clamp(x, min: min, max: max)
}

extension CGRect {
    /// Multiply the rect's origin and size by the given value
    public static func * <U: CGFloatTupleConvertible>(lhs: CGRect, rhs: U) -> CGRect {
        return CGRect(origin: lhs.origin * rhs, size: lhs.size * rhs)
    }
    /// Multiply the rect's origin and size by the given value
    public static func *= <U: CGFloatTupleConvertible>(lhs: inout CGRect, rhs: U) {
        lhs = lhs * rhs
    }
}

