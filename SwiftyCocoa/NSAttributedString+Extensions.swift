//
//  NSAttributedString+Extensions.swift
//  SwiftySwift
//
//  Created by Agustin De Cabrera on 5/18/16.
//  Copyright © 2016 Agustín de Cabrera. All rights reserved.
//

import Foundation

// MARK: NSAttributedString

extension NSAttributedString {
    public convenience init(attributedString attrStr: NSAttributedString, attributes attrs: [NSAttributedStringKey : Any]?) {
        guard let attrs = attrs else {
            self.init(attributedString: attrStr)
            return
        }
        
        let copy = NSMutableAttributedString(attributedString: attrStr)
        copy.addAttributes(attrs)
        self.init(attributedString: copy)
    }
}

// MARK: - NSMutableAttributedString

extension NSMutableAttributedString {
    public func addAttribute(_ name: NSAttributedStringKey, value: Any) {
        addAttribute(name, value: value, range: NSMakeRange(0, self.length))
    }
    
    public func addAttributes(_ attrs: [NSAttributedStringKey : Any]) {
        addAttributes(attrs, range: NSMakeRange(0, self.length))
    }
}

// MARK: - Operators

public func +(lhs: NSAttributedString, rhs: NSAttributedString) -> NSAttributedString {
    let copy = NSMutableAttributedString(attributedString: lhs)
    copy.append(rhs)
    return NSAttributedString(attributedString: copy)
}

public func +=(lhs: inout NSAttributedString, rhs: NSAttributedString) {
    lhs = lhs + rhs
}
