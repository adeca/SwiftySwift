//
//  RangeReplaceableCollectionType+Extensions.swift
//  SwiftySwift
//
//  Created by Agustin De Cabrera on 5/18/16.
//  Copyright © 2016 Agustín de Cabrera. All rights reserved.
//

// MARK: - RangeReplaceableCollectionType

extension RangeReplaceableCollection {
    mutating public func remove(where predicate: (Iterator.Element) -> Bool) -> Iterator.Element? {
        return index(where: predicate).map { remove(at: $0) }
    }
}

extension RangeReplaceableCollection where Iterator.Element : Equatable {
    mutating public func remove(_ element: Iterator.Element) -> Iterator.Element? {
        return index(of: element).map { remove(at: $0) }
    }
}
