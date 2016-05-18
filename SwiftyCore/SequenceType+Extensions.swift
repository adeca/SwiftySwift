//
//  SequenceType+Extensions.swift
//  SwiftySwift
//
//  Created by Agustin De Cabrera on 5/18/16.
//  Copyright © 2016 Agustín de Cabrera. All rights reserved.
//

// MARK: - SequenceType

extension SequenceType where Generator.Element : Equatable {
    /// Return `true` iff all elements of `other` are contained in `self`.
    public func contains<S: SequenceType where S.Generator.Element == Generator.Element>(other: S) -> Bool {
        return other.all { self.contains($0) }
    }
    
    /// Return an `Array` with the elements of self, with all duplicates removed.
    public func filterDuplicates() -> [Self.Generator.Element] {
        var result: [Self.Generator.Element] = []
        for element in self {
            if !result.contains(element) { result.append(element) }
        }
        return result
    }
}

extension SequenceType where Generator.Element : Hashable {
    /// Return `true` iff all elements of `other` are contained in `self`.
    public func contains<S: SequenceType where S.Generator.Element == Generator.Element>(other: S) -> Bool {
        let set = Set(self)
        return other.all { set.contains($0) }
    }
    
    /// Return an `Array` with the elements of self, with all duplicates removed.
    public func filterDuplicates() -> [Self.Generator.Element] {
        var result = Array<Generator.Element>()
        var set    = Set<Generator.Element>()
        
        for element in self {
            if !set.contains(element) { 
                result.append(element) 
                set.insert(element)
            }
        }
        return result
    }
}

extension SequenceType {    
    /// Return `true` if the predicate returns `true` for all elements of `self`
    public func all(@noescape predicate: (Self.Generator.Element) -> Bool) -> Bool {
        for element in self {
            guard predicate(element) else { return false }
        }
        return true
    }
    
    /// Return `true` if the predicate returns `true` for any element in `self`
    public func any(@noescape predicate: (Self.Generator.Element) -> Bool) -> Bool {
        for element in self {
            if predicate(element) { return true }
        }
        return false
    }
    
    /// Return nil is `self` is empty, otherwise return the result of repeatedly 
    /// calling `combine` with each element of `self`, in turn.
    /// i.e. return `combine(combine(...combine(combine(self[0], self[1]),
    /// self[2]),...self[count-2]), self[count-1])`.
    public func reduce(@noescape combine: (Self.Generator.Element, Self.Generator.Element) -> Self.Generator.Element) -> Self.Generator.Element? {
        
        var generator = self.generate()
        guard let first = generator.next() else { 
            return nil 
        }
        
        var result = first
        while let element = generator.next() {
            result = combine(result, element)
        }
        
        return result
    }
    
    /**
     Create a dictionary with the results of applying `transform` to the elements 
     of `self`, using the first tuple component as the key and the second as the value.
     
     Returning `nil` will generate no entry for that element. Returning an existing 
     key will overwrite previous entries.
     */
    public func mapToDictionary<Key: Hashable, Value>(@noescape transform: (Self.Generator.Element) -> (Key, Value)?) -> [Key: Value] {
        let elements = flatMap(transform)
        return Dictionary(elements: elements)
    }
    
    /**
     Create a dictionary with the results of applying `transform` to the elements 
     of `self`, using the returned value as the key and the element as the value.
     
     Returning `nil` will generate no entry for that element. Returning an existing 
     key will overwrite previous entries.
     */
    public func mapToDictionary<Key: Hashable>(@noescape transform: (Self.Generator.Element) -> Key?) -> [Key: Self.Generator.Element] {
        return mapToDictionary { value in
            transform(value).map({ ($0, value) })
        }
    }
    
    /**
     Create a dictionary of arrays based on the results of applying `transform` 
     to the elements of `self`. The first tuple component is used as key and the 
     second is added into an array containing all results that share the same key, 
     which is used as the value.
     
     Returning `nil` will generate no entry for that element.
     */
    public func group<Key: Hashable, Value>(@noescape transform: (Self.Generator.Element) -> (Key, Value)?) -> [Key: [Value]] {
        
        let elements = flatMap(transform)
        let keys = Set(elements.map { $0.0 })
        
        let grouped = keys.map { (key: Key) -> (Key, [Value]) in
            let keyElements = elements.filter { $0.0 == key }
            let values = keyElements.map { $0.1 }
            
            return (key, values)
        }
        
        return Dictionary(elements: grouped)
    }
    
    /**
     Create a dictionary of arrays based on the results of applying `transform` 
     to the elements of `self`. The returned value is used as key and the corresponding 
     element is added into an array containing all results that share the same key, 
     which is used as the value.
     
     Returning `nil` will generate no entry for that element.
     */
    public func group<Key: Hashable>(@noescape transform: (Self.Generator.Element) -> Key?) -> [Key: [Self.Generator.Element]] {
        return group { value in
            transform(value).map({ ($0, value) })
        }
    }
    
    /**
     Create an array of arrays based on the results of applying `transform` 
     to the elements of `self`. The first tuple component is used as the key to 
     group the results, and the second is added into an array containing all results 
     that share the same key.
     
     Returning `nil` will generate no entry for that element.
     */
    public func groupValues<Key: Equatable, Value>(@noescape transform: (Self.Generator.Element) -> (Key, Value)?) -> [[Value]] {
        let elements = flatMap(transform)
        let keys = elements.map { $0.0 }.filterDuplicates()
        return keys.map { key in
            elements.filter { $0.0 == key }.map { $0.1 }
        }
    }
    
    /**
     Create an array of arrays based on the results of applying `transform` 
     to the elements of `self`.The returned value is used as the key to 
     group the results, and corresponding element is added into an array containing 
     all results that share the same key.
     
     Returning `nil` will generate no entry for that element.
     */
    public func groupValues<Key: Equatable>(@noescape transform: (Self.Generator.Element) -> Key?) -> [[Self.Generator.Element]] {
        return groupValues { value in
            transform(value).map({ ($0, value) })
        }
    }
    
    /// Returns the first non-nil value obtained by applying `transform` to the elements of `self`
    public func mapFirst<T>(@noescape transform: (Self.Generator.Element) -> T?) -> T? {        
        for value in self {
            if let result = transform(value) { return result }
        }
        return nil
    }
    
    /// Returns the first non-nil value obtained by applying `transform` to the elements of `self` in reverse order
    public func mapLast<T>(@noescape transform: (Self.Generator.Element) -> T?) -> T? {
        for element in self.lazy.reverse() {
            if let result = transform(element) { return result }
        }
        return nil
    }
    
    /// Use the given closures to extract the values for comparison. If the values 
    /// are equal compare using the next closure in the list until they are all exhausted
    public func minElement(values: ((Self.Generator.Element, Self.Generator.Element) -> NSComparisonResult)...) -> Self.Generator.Element? {
        return minElement(values)
    }
    
    /// Use the given closures to extract the values for comparison. If the values 
    /// are equal compare using the next closure in the list until they are all exhausted
    public func minElement(values: [(Self.Generator.Element, Self.Generator.Element) -> NSComparisonResult]) -> Self.Generator.Element? {
        guard values.count > 0 else { return nil }
        return minElement(orderedBefore(values))
    }
    
    /// Use the given closures to extract the values for comparison. If the values 
    /// are equal compare using the next closure in the list until they are all exhausted
    public func maxElement(values: ((Self.Generator.Element, Self.Generator.Element) -> NSComparisonResult)...) -> Self.Generator.Element? {
        return maxElement(values)
    }
    
    /// Use the given closures to extract the values for comparison. If the values 
    /// are equal compare using the next closure in the list until they are all exhausted
    public func maxElement(values: [(Self.Generator.Element, Self.Generator.Element) -> NSComparisonResult]) -> Self.Generator.Element? {
        guard values.count > 0 else { return nil }
        return maxElement(orderedBefore(values))
    }
    
    /// Use the given closures to extract the values for comparison. If the values 
    /// are equal compare using the next closure in the list until they are all exhausted
    public func sort(values: ((Self.Generator.Element, Self.Generator.Element) -> NSComparisonResult)...) -> [Self.Generator.Element] {
        return sort(values)
    }
    
    /// Use the given closures to extract the values for comparison. If the values 
    /// are equal compare using the next closure in the list until they are all exhausted
    public func sort(values: [(Self.Generator.Element, Self.Generator.Element) -> NSComparisonResult]) -> [Self.Generator.Element] {
        return sort(orderedBefore(values))
    }
}

/// Merge a list of comparison blocks into a single block used for sorting a sequence.
///
/// Use the given closures to extract the values for comparison. If the values 
/// are equal compare using the next closure in the list until they are all exhausted
private func orderedBefore<T>(comparisons: [(T, T) -> NSComparisonResult]) ->  (T, T) -> Bool {
    return { (lhs, rhs) -> Bool in
        for compare in comparisons {
            let result = compare(lhs, rhs)
            if result != .OrderedSame { 
                return result == .OrderedAscending 
            }
        }
        return true
    }
}
