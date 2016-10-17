//
//  UIColor+Extensions.swift
//  SwiftySwift
//
//  Created by Agustin De Cabrera on 5/18/16.
//  Copyright © 2016 Agustín de Cabrera. All rights reserved.
//

import UIKit

// MARK: - UIColor

extension UIColor {
    public typealias RGBA = (r: UInt, g: UInt, b: UInt, a: UInt)
    public convenience init(rgba: RGBA) {        
        self.init(
            rgb: (rgba.r, rgba.g, rgba.b), 
            alpha: CGFloat(rgba.a)/255.0
        )
    }
    
    public typealias RGB = (r: UInt, g: UInt, b: UInt)
    public convenience init(rgb: RGB, alpha: CGFloat = 1.0) {
        self.init(
            red:   CGFloat(rgb.r)/255.0, 
            green: CGFloat(rgb.g)/255.0, 
            blue:  CGFloat(rgb.b)/255.0, 
            alpha: alpha
        )
    }
    
    public convenience init(hex: UInt64, alpha: CGFloat = 1.0) {
        let r = UInt((hex & 0xff0000) >> 16)
        let g = UInt((hex & 0x00ff00) >> 8)
        let b = UInt((hex & 0x0000ff))
        
        self.init(rgb: (r, g, b), alpha: alpha)
    }
    
    public class func randomColor() -> UIColor {
        let component = { CGFloat(drand48()) }
        return UIColor(red: component(), green: component(), blue: component(), alpha: 1.0)
    }
    
    public var rgbComponents: RGB? {
        guard let c = rgbaComponents else { return nil }
        
        return (r: c.r, g: c.g, b: c.b)
    }
    
    public var rgbaComponents: RGBA? {
        guard let c = self.components else { return nil }
        
        return (
            r: UInt(c.r * 255), 
            g: UInt(c.g * 255), 
            b: UInt(c.b * 255), 
            a: UInt(c.a * 255)
        )
    }
    
    public typealias Components = (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat)
    public var components: Components? {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        if self.getRed(&r, green: &g, blue: &b, alpha: &a) {
            return (r, g, b, a)
        } else {
            // Could not extract RGBA components
            return nil
        }
    }
}
