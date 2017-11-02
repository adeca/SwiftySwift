//
//  FloatingPoint+Extensions.swift
//  SwiftyCore
//
//  Copyright © 2017 Agustín de Cabrera. All rights reserved.
//

// MARK: - FloatingPoint

extension FloatingPoint {
    /// Converts the value from degrees to radians.
    public func toRadians() -> Self {
        return (self/180) * type(of: self).pi
    }
    
    /// Converts the value from radians to degrees.
    public func toDegrees() -> Self {
        return (self/type(of: self).pi) * 180
    }
    
    public func ratio(min: Self, max: Self) -> Self {
        return (self - min)/(max - min)
    }
}
