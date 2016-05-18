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
    public func fontWithSymbolicTraits(symbolicTraits: UIFontDescriptorSymbolicTraits) -> UIFont {
        let descriptor = fontDescriptor().fontDescriptorWithSymbolicTraits(symbolicTraits)
        return UIFont(descriptor: descriptor, size: 0)
    }
}
