//
//  StringLiteralConvertible+Extensions.swift
//  SwiftySwift
//
//  Created by Agustin De Cabrera on 5/18/16.
//  Copyright © 2016 Agustín de Cabrera. All rights reserved.
//

// MARK: - StringLiteralConvertible

extension ExpressibleByStringLiteral where StringLiteralType == ExtendedGraphemeClusterLiteralType {
    public init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterLiteralType) {
        self.init(stringLiteral: value)
    }
}

extension ExpressibleByStringLiteral where StringLiteralType == UnicodeScalarLiteralType {
    public init(unicodeScalarLiteral value: UnicodeScalarLiteralType) {
        self.init(stringLiteral: value)
    }
}
