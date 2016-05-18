//
//  Comparable+Extensions.swift
//  SwiftySwift
//
//  Created by Agustin De Cabrera on 5/18/16.
//  Copyright © 2016 Agustín de Cabrera. All rights reserved.
//

// MARK: - Comparable

extension Comparable {
    public func compare(other: Self) -> NSComparisonResult {
        return 
            self < other ?  .OrderedAscending : 
            self == other ? .OrderedSame : 
                            .OrderedDescending
    }
}
