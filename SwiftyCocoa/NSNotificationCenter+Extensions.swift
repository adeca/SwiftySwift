//
//  NSNotificationCenter+Extensions.swift
//  SwiftySwift
//
//  Created by Agustin De Cabrera on 5/18/16.
//  Copyright © 2016 Agustín de Cabrera. All rights reserved.
//

import Foundation

// MARK: - NSNotificationCenter

extension NotificationCenter {
    public func addObserver(forName name: NSNotification.Name?, object: Any? = nil, using block: @escaping (Notification) -> Void) -> NSObjectProtocol {
        return addObserver(forName: name, object: object, queue: nil, using: block)
    }
}
