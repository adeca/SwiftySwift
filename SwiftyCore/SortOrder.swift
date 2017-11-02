//
//  SortOrder.swift
//  SwiftySwift
//
//  Created by Agustin De Cabrera on 5/18/16.
//  Copyright © 2016 Agustín de Cabrera. All rights reserved.
//

//MARK: - SortOrder

/// Determines the possible ways to sort a sequence of Comparable elements
public enum SortOrder {
    case ascending
    case descending
    
    /// Return whether the elements are ordered according to their values and
    /// the current sort order.
    public func isOrderedBefore<T: Comparable>(_ lhs: T, _ rhs: T) -> Bool {
        switch self {
        case .ascending:  return lhs <= rhs
        case .descending: return lhs > rhs
        }
    }
    
    /// Return whether the elements are ordered according to their values and
    /// the current sort order. Nil values are considered 
    /// to be ordered after all others.
    public func isOrderedBefore<T: Comparable>(_ lhs: T?, _ rhs: T?) -> Bool {
        guard let lhs = lhs else { return false }
        guard let rhs = rhs else { return true  }
        
        return isOrderedBefore(lhs, rhs)
    }
}

//MARK: - SequenceType + SortOrder

extension Sequence {
    /// Return an `Array` containing the sorted elements of source according to
    /// the values obtained by applying `transform` to each element.
    public func sorted<T: Comparable>(order sortOrder: SortOrder = .ascending, by transform: (Iterator.Element) -> T) -> [Iterator.Element] {
        return sorted {
            sortOrder.isOrderedBefore(transform($0), transform($1)) 
        }
    }
    
    /// Return an `Array` containing the sorted elements of source according to
    /// the values obtained by applying `transform` to each element. Elements 
    /// that return nil values are placed at the end of the array.
    public func sorted<T: Comparable>(order sortOrder: SortOrder = .ascending, by transform: (Iterator.Element) -> T?) -> [Iterator.Element] {
        return sorted {
            sortOrder.isOrderedBefore(transform($0), transform($1)) 
        }
    }
    
    /// Returns the minimum element in `self` sorted according to
    /// the values obtained by applying `transform` to each element.
    public func min<T: Comparable>(sortOrder: SortOrder = .ascending, by transform: (Self.Iterator.Element) -> T) -> Self.Iterator.Element? {
        return self.min {
            sortOrder.isOrderedBefore(transform($0), transform($1))
        }
    }
    
    /// Returns the maximum element in `self` sorted according to
    /// the values obtained by applying `transform` to each element.
    public func max<T: Comparable>(sortOrder: SortOrder = .ascending, by transform: (Self.Iterator.Element) -> T) -> Self.Iterator.Element? {
        return self.max {
            sortOrder.isOrderedBefore(transform($0), transform($1))
        }
    }
}

extension Sequence where Iterator.Element: Comparable {
    /// Returns the elements of the sequence, sorted using the given sort order.
    public func sorted(order sortOrder: SortOrder) -> [Self.Iterator.Element] {
        return sorted { sortOrder.isOrderedBefore($0, $1) }
    }
}

