//
//  UIFont+Extensions.swift
//  SwiftySwift
//
//  Created by Agustin De Cabrera on 5/18/16.
//  Copyright © 2016 Agustín de Cabrera. All rights reserved.
//

import UIKit

// MARK: - UIFont

extension UIFont {
    public func fontWithSymbolicTraits(_ symbolicTraits: UIFontDescriptorSymbolicTraits) -> UIFont {
        let currentDescriptor = fontDescriptor
        let descriptor = currentDescriptor.withSymbolicTraits(symbolicTraits) ?? currentDescriptor
        return UIFont(descriptor: descriptor, size: 0)
    }
}
