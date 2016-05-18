//
//  RangeReplaceableCollectionType+Extensions.swift
//  SwiftySwift
//
//  Created by Agustin De Cabrera on 5/18/16.
//  Copyright © 2016 Agustín de Cabrera. All rights reserved.
//

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
