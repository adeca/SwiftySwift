//
//  OptionalConvertible.swift
//  SwiftySwift
//
//  Created by Agustin De Cabrera on 5/18/16.
//  Copyright © 2016 Agustín de Cabrera. All rights reserved.
//

// MARK: - OptionalConvertible

/// A type that can be represented as an `Optional`
public protocol OptionalConvertible {
    associatedtype SomeValue
    
    var optionalValue: SomeValue? { get }
}

extension Optional: OptionalConvertible {
    public var optionalValue: Wrapped? { return self }
}

// MARK: - SequenceType + OptionalConvertible

extension Sequence where Iterator.Element : OptionalConvertible {
    /// return an `Array` containing the non-nil values in `self`
    @available(*, deprecated)
    public func flatMap() -> [Iterator.Element.SomeValue] {
        return removingNilValues()
    }
    
    /// return an `Array` containing the non-nil values in `self`
    public func removingNilValues() -> [Iterator.Element.SomeValue] {
        var result: [Iterator.Element.SomeValue] = []
        for element in self {
            if let value = element.optionalValue {
                result.append(value)
            }
        }
        return result
    }
}

/// Returns `true` if these arrays contain the same elements in the same order.
public func ==<T: OptionalConvertible>(lhs: [T], rhs: [T]) -> Bool where T.SomeValue: Equatable {
    return !(lhs != rhs)
}

/// Returns `true` if these arrays do not contain the same elements in the same order.
public func != <T: OptionalConvertible>(lhs: [T], rhs: [T]) -> Bool where T.SomeValue: Equatable {
    return lhs.count != rhs.count
        || zip(lhs, rhs).contains(where: { $0.optionalValue != $1.optionalValue })
}
