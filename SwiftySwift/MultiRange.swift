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

public func ..< <T : ForwardIndexType>(start: (T, T), end: (T, T)) -> MultiRange<T> {
    return MultiRange(
        rows:    start.0 ..< end.0, 
        columns: start.1 ..< end.1
    )
}

public func ... <T : ForwardIndexType>(start: (T, T), end: (T, T)) -> MultiRange<T> {
    return MultiRange(
        rows:    start.0 ... end.0, 
        columns: start.1 ... end.1
    )
}

public struct MultiRange<T: ForwardIndexType> : Equatable, SequenceType, CustomStringConvertible, CustomDebugStringConvertible {
    private let rows: Range<T>
    private let columns: Range<T>
    
    init(rows: Range<T>, columns: Range<T>) {
        self.rows = rows
        self.columns = columns
    }
    
    public func generate() -> AnyGenerator<(T, T)> {
        return multiRangeGenerator(rows, columns)
    }
    
    public func contains(element: (T, T)) -> Bool {
        return any { $0 == element }
    }
    
    public func underestimateCount() -> Int {
        return rows.underestimateCount() * columns.underestimateCount()
    }
    
    public var description: String {
        return "(\(rows.startIndex), \(columns.startIndex))..<(\(rows.endIndex), \(columns.endIndex))"
    }
    
    public var debugDescription: String {
        return "MultiRange(\(description))"
    }
}

public func == <T>(lhs: MultiRange<T>, rhs: MultiRange<T>) -> Bool {
    return lhs.rows == rhs.rows && lhs.columns == rhs.columns
}

private func multiRangeGenerator<T>(rows: Range<T>, _ columns: Range<T>) -> AnyGenerator<(T, T)> {    
    // lazy generators for each row and column
    var rowGenerators = rows.lazy.map { r in 
        columns.lazy.map { c in 
            (r, c) 
            }.generate()
        }.generate()
    
    var current = rowGenerators.next()
    return anyGenerator {
        if let next = current?.next() {
            return next
        } else {
            current = rowGenerators.next()
            return current?.next()
        }
    }
}
