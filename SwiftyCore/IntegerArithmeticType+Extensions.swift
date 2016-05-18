//
//  IntegerArithmeticType+Extensions.swift
//  SwiftySwift
//
//  Created by Agustin De Cabrera on 5/18/16.
//  Copyright © 2016 Agustín de Cabrera. All rights reserved.
//

// MARK: - IntegerArithmeticType

extension IntegerArithmeticType where Self: IntegerLiteralConvertible {
    public var isEven: Bool { return (self % 2) == 0 }
    public var isOdd: Bool  { return !isEven }
}

extension CollectionType where Generator.Element: IntegerArithmeticType {
    public func sum() -> Generator.Element? {
        return reduce(+)
    }
    
    //    public func average() -> Generator.Element? {
    //        return sum().map {
    //            Generator.Element(Double($0)/Double(count))
    //        }
    //    }
}
