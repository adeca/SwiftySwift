//
//  Dictionary+Extensions.swift
//  SwiftySwift
//
//  Created by Agustin De Cabrera on 5/18/16.
//  Copyright © 2016 Agustín de Cabrera. All rights reserved.
//

// MARK: - Dictionary

extension Dictionary {
    public init<S: Sequence>(elements: S) where S.Iterator.Element == (Key, Value) {
        self.init()
        update(withContentsOf: elements)
    }
    
    public init<C: Collection>(elements: C) where C.Iterator.Element == (Key, Value), C.IndexDistance == Int {
        self.init(minimumCapacity: elements.count)
        update(withContentsOf: elements)
    }   
    
    /// Update the values stored in the dictionary with the given key-value pairs, or, if a key does not exist, add a new entry.
    @discardableResult
    public mutating func update<S: Sequence>(withContentsOf newElements: S) -> [Value] 
        where S.Iterator.Element == (Key, Value) {
        return newElements.flatMap { (k, v) in 
            updateValue(v, forKey: k) 
        }
    }
    
    /// Update the values stored in the dictionary with the given key-value pairs, or, if a key does not exist, add a new entry.
    @discardableResult
    public mutating func update<S: Sequence>(withContentsOf newElements: S) -> [Value] 
        where S.Iterator.Element == Element {
        return newElements.flatMap { (k, v) in
            updateValue(v, forKey: k) 
        }
    }
    
    // MARK: Operators
    // TODO: Disabled for now. the compiler keeps throwing weird errors for the operators.
    
//    /// Return a new dictionary created by extending the lef-side dictionary with the elements of the right-side dictionary
//    public static func + <Key: Hashable, Value>(lhs: [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
//        var result = lhs
//        result.update(withContentsOf: rhs)
//        return result
//    }
//    
//    public static func += <Key: Hashable, Value>(lhs: inout [Key: Value], rhs: [Key: Value]) {
//        lhs.update(withContentsOf: rhs)
//    }
//    
//    public static func += <Key: Hashable, Value, S: Sequence>(lhs: inout Dictionary<Key, Value>, rhs: Dictionary<Key, Value>) 
//        where S.Iterator.Element == (Key, Value) {
//        lhs.update(withContentsOf: rhs)
//    }
}
