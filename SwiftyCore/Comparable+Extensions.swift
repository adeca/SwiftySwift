//
//  Comparable+Extensions.swift
//  SwiftySwift
//
//  Created by Agustin De Cabrera on 5/18/16.
//  Copyright © 2016 Agustín de Cabrera. All rights reserved.
//

// MARK: - Comparable

extension Comparable {
    public func compare(_ other: Self) -> ComparisonResult {
        return 
            self < other ?  .orderedAscending : 
            self == other ? .orderedSame : 
                            .orderedDescending
    }
}
