//
//  NSAttributedString+Extensions.swift
//  SwiftySwift
//
//  Created by Agustin De Cabrera on 5/18/16.
//  Copyright © 2016 Agustín de Cabrera. All rights reserved.
//

import Foundation

// MARK: - NSMutableAttributedString

extension NSMutableAttributedString {
    public func addAttribute(name: String, value: AnyObject) {
        addAttribute(name, value: value, range: NSMakeRange(0, self.length))
    }
    
    public func addAttributes(attrs: [String : AnyObject]) {
        addAttributes(attrs, range: NSMakeRange(0, self.length))
    }
}
