//
//  CollectionType+Extensions.swift
//  SwiftySwift
//
//  Created by Agustin De Cabrera on 5/18/16.
//  Copyright © 2016 Agustín de Cabrera. All rights reserved.
//

// MARK: - CollectionType

extension Collection {
    /// Returns a tuple composed of: the first element in the collection, and
    /// the collection without the first element.
    public func decompose() -> (Iterator.Element, SubSequence)? {
        return first.map { ($0, dropFirst()) }
    }
}

extension Collection where Iterator.Element : Equatable {
    public func first(equalTo element: Iterator.Element) -> Iterator.Element? {
        return first { $0 == element }
    }
}

extension Collection where Index == Int, IndexDistance == Int {
    public func randomElement() -> Iterator.Element? {
        let count = UInt32(self.count)
        guard count > 0 else { return nil }
        
        let idx = Int(arc4random_uniform(count))
        return self[idx]
    }
}

extension Collection where Iterator.Element: Numeric {
    public func sum() -> Iterator.Element? {
        return reduce(+)
    }
}

extension Collection where Index == Int {
    /// Returns the element at the given index, or `nil` if the index is out of bounds.
    public func at(_ index: Int) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
