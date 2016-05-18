//
//  CollectionType+Extensions.swift
//  SwiftySwift
//
//  Created by Agustin De Cabrera on 5/18/16.
//  Copyright © 2016 Agustín de Cabrera. All rights reserved.
//

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
