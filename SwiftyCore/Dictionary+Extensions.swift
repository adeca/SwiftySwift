//
//  Dictionary+Extensions.swift
//  SwiftySwift
//
//  Created by Agustin De Cabrera on 5/18/16.
//  Copyright © 2016 Agustín de Cabrera. All rights reserved.
//

// MARK: - Dictionary

extension Dictionary {
    public init<S: Sequence>(elements: S) where S.Element == (Key, Value) {
        self = Dictionary(elements, uniquingKeysWith: { (_, new) in new })
    }
    
    /// Update the values stored in the dictionary with the given key-value pairs, or, if a key does not exist, add a new entry.
    @discardableResult
    public mutating func update<S: Sequence>(withContentsOf newElements: S) -> [Value] 
        where S.Element == (Key, Value) {
            return newElements.compactMap { (k, v) in
                updateValue(v, forKey: k)
            }
    }
    
    /// Update the values stored in the dictionary with the given key-value pairs, or, if a key does not exist, add a new entry.
    @discardableResult
    public mutating func update<S: Sequence>(withContentsOf newElements: S) -> [Value] 
        where S.Element == Element {
            return newElements.compactMap { (k, v) in
                updateValue(v, forKey: k)
            }
    }
}
