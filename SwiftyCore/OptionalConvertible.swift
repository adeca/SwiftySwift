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

extension SequenceType where Self.Generator.Element : OptionalConvertible {
    /// return an `Array` containing the non-nil values in `self`
    public func flatMap() -> [Self.Generator.Element.SomeValue] {
        return flatMap { $0.optionalValue }
    }
}
