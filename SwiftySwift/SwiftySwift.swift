//
//  SwiftySwift.swift
//  SwiftySwift
//
//  Created by Agustín de Cabrera on 6/1/15.
//  Copyright (c) 2015 Agustín de Cabrera. All rights reserved.
//

import Foundation

// MARK: - cast helpers

/**
The following methods can be used to perform a cast without being explicit 
about the class the object is being cast to, relying instead on the type-inferrence
features of the compiler.

This allows creating class methods that return an instance of the subclass they are called on.

e.g.

    class A {
     class func factoryMethod() -> Self? {
      let instance = createNewInstance()
      return cast(instance)
     }
    }
    
    class B : A {
    }
    
    A.factoryMethod()  // type is inferred as A?
    B.factoryMethod()  // type is inferred as B?
**/

/// Optional cast of `x` as type `V`
public func cast<U, V>(x: U) -> V? {
    return x as? V
}

/// Return all values of `source` that were successfully casted to type `V`
public func castFilter<S: SequenceType, V>(source: S) -> [V] {
    return source.flatMap {
        $0 as? V
    }
}

/// Return the first value of `source` that was successfully casted to type `V`
public func castFirst<S: SequenceType, V>(source: S) -> V? {
    return source.flatMap {
        $0 as? V
    }.first
}

/// Forced cast of `x` as type `V`
public func forcedCast<U, V>(x: U) -> V {
    return x as! V
}

public func stringFromClass(aClass: AnyClass) -> String {
    return NSStringFromClass(aClass).componentsSeparatedByString(".").last!
}

// MARK: - Comparable

extension Comparable {
    public func compare(other: Self) -> NSComparisonResult {
        return self < other ? .OrderedAscending : 
            self == other ? .OrderedSame : 
            .OrderedDescending
    }
}

// MARK: - Equatable

public func == <T: Equatable>(lhs: (T, T), rhs: (T, T)) -> Bool {
    return lhs.0 == rhs.0 && lhs.1 == rhs.1
}

// MARK: - Optional

extension Optional {
    /// If `self != nil` executes `f(self!)`.
    public func unwrap(@noescape f: (Wrapped) throws -> ()) rethrows {
        if let value = self { 
            try f(value) 
        }
    }
}

// MARK: - OptionalConvertible

/// A type that can be represented as an `Optional`
public protocol OptionalConvertible {
    typealias SomeValue
    
    var optionalValue: SomeValue? { get }
}

extension Optional: OptionalConvertible {
    public var optionalValue: Wrapped? { return self }
}

// MARK: - SequenceType

extension SequenceType where Self.Generator.Element : OptionalConvertible {
    /// return an `Array` containing the non-nil values in `self`
    public func flatMap() -> [Self.Generator.Element.SomeValue] {
        return flatMap { $0.optionalValue }
    }
}

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

//MARK: - SortOrder

/// Determines the possible ways to sort a sequence of Comparable elements
public enum SortOrder {
    case Ascending
    case Descending
    
    /// Return whether the elements are ordered according to their values and
    /// the current sort order.
    public func isOrderedBefore<T: Comparable>(lhs: T, _ rhs: T) -> Bool {
        switch self {
        case .Ascending:  return lhs <= rhs
        case .Descending: return lhs > rhs
        }
    }
    
    /// Return whether the elements are ordered according to their values and
    /// the current sort order. Nil values are considered 
    /// to be ordered after all others.
    public func isOrderedBefore<T: Comparable>(lhs: T?, _ rhs: T?) -> Bool {
        guard let lhs = lhs else { return false }
        guard let rhs = rhs else { return true  }
        
        return isOrderedBefore(lhs, rhs)
    }
}

extension SequenceType {
    /// Return an `Array` containing the sorted elements of source according to
    /// the values obtained by applying `transform` to each element.
    public func sort<T: Comparable>(sortOrder: SortOrder = .Ascending, transform: Self.Generator.Element -> T) -> [Self.Generator.Element] {
        return sort {
            sortOrder.isOrderedBefore(transform($0), transform($1)) 
        }
    }
    
    /// Return an `Array` containing the sorted elements of source according to
    /// the values obtained by applying `transform` to each element. Elements 
    /// that return nil values are placed at the end of the array.
    public func sort<T: Comparable>(sortOrder: SortOrder = .Ascending, transform: Self.Generator.Element -> T?) -> [Self.Generator.Element] {
        return sort {
            sortOrder.isOrderedBefore(transform($0), transform($1)) 
        }
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

// MARK: - RangeReplaceableCollectionType

extension RangeReplaceableCollectionType {
    mutating public func remove(@noescape predicate: (Self.Generator.Element) -> Bool) -> Self.Generator.Element? {
        return indexOf(predicate).map { removeAtIndex($0) }
    }
}

extension RangeReplaceableCollectionType where Generator.Element : Equatable {
    mutating public func remove(element: Self.Generator.Element) -> Self.Generator.Element? {
        return indexOf(element).map { removeAtIndex($0) }
    }
}

// MARK: - CollectionType

extension CollectionType {
    public func decompose() -> (Self.Generator.Element, Self.SubSequence)? {
        return first.map { ($0, dropFirst()) }
    }
    
    public func find(@noescape predicate: (Self.Generator.Element) -> Bool) -> Self.Generator.Element? {
        return indexOf(predicate).map { self[$0] }
    }
}

extension CollectionType where Generator.Element : Equatable {
    public func find(element: Self.Generator.Element) -> Self.Generator.Element? {        
        return indexOf(element).map { self[$0] }
    }
}

extension CollectionType where Index == Int {
    public func randomElement() -> Self.Generator.Element {
        let idx = Int(arc4random_uniform(UInt32(count)))
        return self[idx]
    }
}

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

/// Return a new dictionary created by extending the lef-side dictionary with the elements of the right-side dictionary
public func + <K, V, S: SequenceType where S.Generator.Element == (K, V)>(lhs: [K: V], rhs: S) -> [K: V] {
    var result = lhs
    result.extend(rhs)
    return result
}
public func += <K, V>(inout lhs: [K: V], rhs: [K: V]) {
    lhs = lhs + rhs
}

// MARK: - math

public func clamp<T: Comparable>(x: T, _ low: T, _ high: T) -> T {
    return (x < low) ? low : (x > high) ? high : x
}

/// Formal protocol to encapsulate the operations that are available to many floating point types
public protocol FloatingPointArithmeticType : FloatingPointType {
    func +(lhs: Self, rhs: Self) -> Self
    func -(lhs: Self, rhs: Self) -> Self
    func *(lhs: Self, rhs: Self) -> Self
    func /(lhs: Self, rhs: Self) -> Self
}
extension Double : FloatingPointArithmeticType {}
extension Float : FloatingPointArithmeticType {}
extension CGFloat: FloatingPointArithmeticType {}

/// Linear interpolation between two values
public func lerp<T: FloatingPointArithmeticType>(from: T, _ to: T, _ progress: T) -> T {
    return from * (T(1) - progress) + to * progress
}

public func sign<T: SignedNumberType>(x: T) -> T {
    return x == 0 ? 0 : x == abs(x) ? 1 : -1
}

public func sign<T: UnsignedIntegerType>(x: T) -> T {
    return x == 0 ? 0 : 1
}

public func mod(lhs: Int, _ rhs: Int) -> Int {
    return (lhs % rhs + rhs) % rhs
}

public func min<T : Comparable>(t: (T, T)) -> T {
    return min(t.0, t.1)
}

public func max<T : Comparable>(t: (T, T)) -> T {
    return max(t.0, t.1)
}
