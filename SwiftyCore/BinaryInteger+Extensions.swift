//
//  BinaryInteger+Extensions.swift
//  SwiftySwift
//
//  Created by Agustin De Cabrera on 5/18/16.
//  Copyright © 2016 Agustín de Cabrera. All rights reserved.
//

// MARK: - BinaryInteger

extension BinaryInteger {
    public var isEven: Bool { return (self % 2) == 0 }
    public var isOdd: Bool  { return !isEven }
}

