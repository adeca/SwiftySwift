//
//  Optional+Extensions.swift
//  SwiftySwift
//
//  Created by Agustin De Cabrera on 5/18/16.
//  Copyright © 2016 Agustín de Cabrera. All rights reserved.
//

// MARK: - Optional

extension Optional {
    /// If `self != nil` executes `f(self!)`.
    public func unwrap(@noescape f: (Wrapped) throws -> ()) rethrows {
        if let value = self { 
            try f(value) 
        }
    }
}
