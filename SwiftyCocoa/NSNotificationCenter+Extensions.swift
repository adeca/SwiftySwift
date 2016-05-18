//
//  NSNotificationCenter+Extensions.swift
//  SwiftySwift
//
//  Created by Agustin De Cabrera on 5/18/16.
//  Copyright © 2016 Agustín de Cabrera. All rights reserved.
//

import Foundation

// MARK: - NSNotificationCenter

extension NSNotificationCenter {
    public func addObserverForName(name: String?, object: AnyObject? = nil, usingBlock block: (NSNotification) -> Void) -> NSObjectProtocol {
        return addObserverForName(name, object: object, queue: nil, usingBlock: block)
    }
}
