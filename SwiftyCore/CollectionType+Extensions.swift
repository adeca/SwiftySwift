//
//  CollectionType+Extensions.swift
//  SwiftySwift
//
//  Created by Agustin De Cabrera on 5/18/16.
//  Copyright © 2016 Agustín de Cabrera. All rights reserved.
//

// MARK: - CollectionType

extension Collection {
    public func decompose() -> (Iterator.Element, SubSequence)? {
        return first.map { ($0, dropFirst()) }
    }
    
    // DEPRECATED: use first(where:) instead
    @available(*, deprecated)
    public func find(_ predicate: (Iterator.Element) throws -> Bool) rethrows -> Iterator.Element? {
        return try first(where: predicate)
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
