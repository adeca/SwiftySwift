//
//  CGGeometry+CGFloatTuple.swift
//  SwiftySwift
//
//  Created by Agustin De Cabrera on 5/18/16.
//  Copyright © 2016 Agustín de Cabrera. All rights reserved.
//

import CoreGraphics

/// CGPoint, CGVector and CGSize can be converted to a pair of floats.
/// Conforming to CGFloatTupleConvertible allows using the operators defined above. 

extension CGPoint: CGFloatTupleConvertible {
    public var tuple: CGFloatTuple { return (x, y) }
    
    public init(tuple: CGFloatTuple) {
        self.init(x: tuple.0, y: tuple.1)
    }
}

extension CGSize: CGFloatTupleConvertible {    
    public var tuple: CGFloatTuple { return (width, height) }
    
    public init(tuple: CGFloatTuple) {
        self.init(width: tuple.0, height: tuple.1)
    }
}

extension CGVector: CGFloatTupleConvertible {
    public var tuple: CGFloatTuple { return (dx, dy) }
    
    public init(tuple: CGFloatTuple) {
        self.init(dx: tuple.0, dy: tuple.1)
    }
}
