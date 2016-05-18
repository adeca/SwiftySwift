//
//  Dictionary+Extensions.swift
//  SwiftySwift
//
//  Created by Agustin De Cabrera on 5/18/16.
//  Copyright © 2016 Agustín de Cabrera. All rights reserved.
//

// MARK: - Dictionary

extension Dictionary {
    public init<S: SequenceType where S.Generator.Element == (Key, Value)>(elements: S) {
        self.init()
        extend(elements)
    }
    
    public init<C: CollectionType where C.Generator.Element == (Key, Value), C.Index.Distance == Int>(elements: C) {
        self.init(minimumCapacity: elements.count)
        extend(elements)
    }   
    
    /// Update the values stored in the dictionary with the given key-value pairs, or, if a key does not exist, add a new entry.
    public mutating func extend<S: SequenceType where S.Generator.Element == Generator.Element>(newElements: S) -> [Value] {
        return newElements.flatMap { 
            (k, v) in updateValue(v, forKey: k) 
        }
    }
}

// MARK: - Operators

/// Return a new dictionary created by extending the lef-side dictionary with the elements of the right-side dictionary
public func + <K, V, S: SequenceType where S.Generator.Element == (K, V)>(lhs: [K: V], rhs: S) -> [K: V] {
    var result = lhs
    result.extend(rhs)
    return result
}
public func += <K, V>(inout lhs: [K: V], rhs: [K: V]) {
    lhs = lhs + rhs
}
