//
//  SequenceType+Extensions.swift
//  SwiftySwift
//
//  Created by Agustin De Cabrera on 5/18/16.
//  Copyright © 2016 Agustín de Cabrera. All rights reserved.
//

// MARK: - SequenceType

extension Sequence where Iterator.Element : Equatable {
    /// Return `true` iff all elements of `other` are contained in `self`.
    public func contains<S: Sequence>(_ other: S) -> Bool where S.Element == Element {
        return other.all { self.contains($0) }
    }
    
    /// Return an `Array` with the elements of self, with all duplicates removed.
    public func filteringDuplicates() -> [Iterator.Element] {
        var result: [Iterator.Element] = []
        for element in self {
            if !result.contains(element) { result.append(element) }
        }
        return result
    }
}

extension Sequence where Iterator.Element : Hashable {
    /// Return `true` iff all elements of `other` are contained in `self`.
    public func contains<S: Sequence>(_ other: S) -> Bool where S.Iterator.Element == Iterator.Element {
        let set = Set(self)
        return other.all { set.contains($0) }
    }
    
    /// Return an `Array` with the elements of self, with all duplicates removed.
    public func filteringDuplicates() -> [Iterator.Element] {
        var result = Array<Iterator.Element>()
        var set    = Set<Iterator.Element>()
        
        for element in self {
            if !set.contains(element) { 
                result.append(element) 
                set.insert(element)
            }
        }
        return result
    }
}

extension Sequence {    
    /// Return `true` if the predicate returns `true` for all elements of `self`
    public func all(_ predicate: (Iterator.Element) -> Bool) -> Bool {
        for element in self {
            guard predicate(element) else { return false }
        }
        return true
    }
    
    /// Return `true` if the predicate returns `true` for any element in `self`
    public func any(_ predicate: (Iterator.Element) -> Bool) -> Bool {
        for element in self {
            if predicate(element) { return true }
        }
        return false
    }
        
    /// Return nil is `self` is empty, otherwise return the result of repeatedly 
    /// calling `combine` with each element of `self`, in turn.
    /// i.e. return `combine(combine(...combine(combine(self[0], self[1]),
    /// self[2]),...self[count-2]), self[count-1])`.
    public func reduce(_ nextPartialResult: (Iterator.Element, Iterator.Element) throws -> Iterator.Element) rethrows -> Iterator.Element? {
        
        var generator = self.makeIterator()
        guard let first = generator.next() else { 
            return nil 
        }
        
        var result = first
        while let element = generator.next() {
            result = try nextPartialResult(result, element)
        }
        
        return result
    }
    
    /**
     Create a dictionary with the results of applying `transform` to the elements 
     of `self`, using the first tuple component as the key and the second as the value.
     
     Returning `nil` will generate no entry for that element. Returning an existing 
     key will overwrite previous entries.
     */
    public func mapToDictionary<Key, Value>(_ transform: (Iterator.Element) -> (Key, Value)?) -> [Key: Value] {
        let elements = compactMap(transform)
        return Dictionary(elements, uniquingKeysWith: { _, new in new })
    }
    
    /**
     Create a dictionary with the results of applying `transform` to the elements 
     of `self`, using the returned value as the key and the element as the value.
     
     Returning `nil` will generate no entry for that element. Returning an existing 
     key will overwrite previous entries.
     */
    public func mapToDictionary<Key>(_ transform: (Iterator.Element) -> Key?) -> [Key: Iterator.Element] {
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
    public func groupBy<Key, Value>(_ transform: (Iterator.Element) -> (Key, Value)?) -> [Key: [Value]] {
        let elements = compactMap(transform).map { ($0, [$1]) }
        return Dictionary.init(elements, uniquingKeysWith: +)
    }
    
    /**
     Create a dictionary of arrays based on the results of applying `transform` 
     to the elements of `self`. The returned value is used as key and the corresponding 
     element is added into an array containing all results that share the same key, 
     which is used as the value.
     
     Returning `nil` will generate no entry for that element.
     */
    public func groupBy<Key>(_ transform: (Iterator.Element) -> Key?) -> [Key: [Iterator.Element]] {
        let elements = compactMap({ value in
            transform(value).map({ ($0, [value]) })
        })
        return Dictionary.init(elements, uniquingKeysWith: +)
    }
    
    /**
     Create an array of arrays based on the results of applying `transform` 
     to the elements of `self`. The first tuple component is used as the key to 
     group the results, and the second is added into an array containing all results 
     that share the same key.
     
     Returning `nil` will generate no entry for that element.
     */
    public func groupValues<Key: Equatable, Value>(_ transform: (Iterator.Element) -> (Key, Value)?) -> [[Value]] {
        let elements = compactMap(transform)
        let keys = elements.map { $0.0 }.filteringDuplicates()
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
    public func groupValues<Key: Equatable>(_ transform: (Iterator.Element) -> Key?) -> [[Iterator.Element]] {
        return groupValues { value in
            transform(value).map({ ($0, value) })
        }
    }
    
    /**
     Returns a tuple containing, in order, the elements of the sequence divided into two
     arrays, with one containing the elements that satisfy the given predicate and the
     other the elements that don't.
     */
    public func groupFilter(_ includeElement: (Self.Iterator.Element) -> Bool) -> (included: [Self.Iterator.Element], excluded: [Self.Iterator.Element]) {
        // group included and excluded elements using the result of the block (true/false)
        let grouped = self.groupBy {
            includeElement($0)
        }
        return (grouped[true] ?? [], grouped[false] ?? [])
    }
    
    /// Returns the first non-nil value obtained by applying `transform` to the elements of `self`
    public func mapFirst<T>(_ transform: (Iterator.Element) -> T?) -> T? {        
        for value in self {
            if let result = transform(value) { return result }
        }
        return nil
    }
    
    /// Returns the first non-nil value obtained by applying `transform` to the elements of `self` in reverse order
    public func mapLast<T>(_ transform: (Iterator.Element) -> T?) -> T? {
        for element in self.lazy.reversed() {
            if let result = transform(element) { return result }
        }
        return nil
    }
        
    /// Use the given closures to extract the values for comparison. If the values 
    /// are equal compare using the next closure in the list until they are all exhausted
    public func min(by values: ((Iterator.Element, Iterator.Element) -> ComparisonResult)...) -> Iterator.Element? {
        return self.min(by: values)
    }
    
    /// Use the given closures to extract the values for comparison. If the values 
    /// are equal compare using the next closure in the list until they are all exhausted
    public func min(by values: [(Iterator.Element, Iterator.Element) -> ComparisonResult]) -> Iterator.Element? {
        guard values.count > 0 else { return nil }
        return self.min(by: orderedBefore(values))
    }
    
    /// Use the given closures to extract the values for comparison. If the values 
    /// are equal compare using the next closure in the list until they are all exhausted
    public func max(by values: ((Iterator.Element, Iterator.Element) -> ComparisonResult)...) -> Iterator.Element? {
        return self.max(by: values)
    }
    
    /// Use the given closures to extract the values for comparison. If the values 
    /// are equal compare using the next closure in the list until they are all exhausted
    public func max(by values: [(Iterator.Element, Iterator.Element) -> ComparisonResult]) -> Iterator.Element? {
        guard values.count > 0 else { return nil }
        return self.max(by: orderedBefore(values))
    }
    
    /// Use the given closures to extract the values for comparison. If the values 
    /// are equal compare using the next closure in the list until they are all exhausted
    public func sorted(by values: ((Iterator.Element, Iterator.Element) -> ComparisonResult)...) -> [Iterator.Element] {
        return sorted(by: values)
    }
    
    /// Use the given closures to extract the values for comparison. If the values 
    /// are equal compare using the next closure in the list until they are all exhausted
    public func sorted(by values: [(Iterator.Element, Iterator.Element) -> ComparisonResult]) -> [Iterator.Element] {
        return sorted(by: orderedBefore(values))
    }
}

/// Merge a list of comparison blocks into a single block used for sorting a sequence.
///
/// Use the given closures to extract the values for comparison. If the values 
/// are equal compare using the next closure in the list until they are all exhausted
private func orderedBefore<T>(_ comparisons: [(T, T) -> ComparisonResult]) ->  (T, T) -> Bool {
    return { (lhs, rhs) -> Bool in
        for compare in comparisons {
            let result = compare(lhs, rhs)
            if result != .orderedSame { 
                return result == .orderedAscending 
            }
        }
        return true
    }
}
