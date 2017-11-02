//
//  UnsignedInteger+Extensions.swift
//  SwiftySwift
//
//  Copyright © 2017 Agustín de Cabrera. All rights reserved.
//

extension UnsignedInteger {
    var sign: Self {
        return self == 0 ? 0 : 1
    }
}
