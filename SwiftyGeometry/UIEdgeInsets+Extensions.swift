//
//  UIEdgeInsets+Extensions.swift
//  SwiftySwift
//
//  Created by Agustin De Cabrera on 5/18/16.
//  Copyright © 2016 Agustín de Cabrera. All rights reserved.
//

import UIKit

// MARK: - UIEdgeInsets

extension UIEdgeInsets {
    public var topLeft: CGPoint { 
        return CGPoint(x: left, y: top) 
    }
    public var bottomRight: CGPoint {
        return CGPoint(x: right, y: bottom) 
    }
    
    public static var zero: UIEdgeInsets = UIEdgeInsetsZero
}
