//
//  MultiRange.swift
//  SwiftySwift
//
//  Created by Agustín de Cabrera on 10/27/15.
//  Copyright © 2015 Agustín de Cabrera. All rights reserved.
//

/**
Useful methods to iterate over a grid

These methods return a sequence that can be iterated over, and will provide a 
tuple for each combination between the start and end tuples

e.g.: (1,1)...(2,2) will generate (1,1), (1,2), (2,1), (2,2)
**/

public func ..< <T>(start: (T, T), end: (T, T)) -> MultiRange<T> 
    where T: Strideable & Comparable, T.Stride: SignedInteger {
    return MultiRange(
        rows:    start.0 ..< end.0, 
        columns: start.1 ..< end.1
    )
}

public func ... <T>(start: (T, T), end: (T, T)) -> MultiRange<T> 
    where T: Strideable & Comparable, T.Stride: SignedInteger {
    return MultiRange(
        rows:    CountableRange(start.0 ... end.0), 
        columns: CountableRange(start.1 ... end.1)
    )
}

public struct MultiRange<T> : Equatable, Sequence, CustomStringConvertible, CustomDebugStringConvertible 
    where T: Strideable & Comparable, T.Stride: SignedInteger {
    
    private let rows: CountableRange<T>
    private let columns: CountableRange<T>
    
    init(rows: CountableRange<T>, columns: CountableRange<T>) {
        self.rows = rows
        self.columns = columns
    }
    
    public func makeIterator() -> AnyIterator<(T, T)> {
        return multiRangIterator(rows, columns)
    }
    
    public func contains(_ element: (T, T)) -> Bool {
        return contains { $0 == element.0 && $1 == element.1 }
    }
    
    public func underestimateCount() -> Int {
        return rows.underestimatedCount * columns.underestimatedCount
    }
    
    public var description: String {
        return "(\(rows.lowerBound), \(columns.lowerBound))..<(\(rows.upperBound), \(columns.upperBound))"
    }
    
    public var debugDescription: String {
        return "MultiRange(\(description))"
    }
    
    public static func == <T>(lhs: MultiRange<T>, rhs: MultiRange<T>) -> Bool {
        return lhs.rows == rhs.rows && lhs.columns == rhs.columns
    }
}

private func multiRangIterator<T>(_ rows: CountableRange<T>, _ columns: CountableRange<T>) -> AnyIterator<(T, T)> {    
    // lazy generators for each row and column
    let lazyPointSequence = rows.lazy.map { r in 
        columns.lazy.map({ c in (r, c) })
    }
    let columnIterators = lazyPointSequence.map { $0.makeIterator() }
    var rowIterator = columnIterators.makeIterator()
    
    var current = rowIterator.next()
    return AnyIterator() {
        if let next = current?.next() {
            return next
        } else {
            current = rowIterator.next()
            return current?.next()
        }
    }
}
