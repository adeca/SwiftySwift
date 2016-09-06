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
    public func addAttribute(_ name: String, value: Any) {
        addAttribute(name, value: value, range: NSMakeRange(0, self.length))
    }
    
    public func addAttributes(_ attrs: [String : Any]) {
        addAttributes(attrs, range: NSMakeRange(0, self.length))
    }
}
