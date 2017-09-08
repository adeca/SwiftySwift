//
//  SignedNumeric+Extensions.swift
//  SwiftySwift
//
//  Copyright © 2017 Agustín de Cabrera. All rights reserved.
//

extension SignedNumeric where Self.Magnitude == Self {
    public var sign: Self {
        return self == 0 ? 0 : self == abs(self) ? 1 : -1
    }
}
