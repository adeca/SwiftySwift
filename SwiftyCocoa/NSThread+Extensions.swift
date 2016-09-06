//
//  NSThread+Extensions.swift
//  SwiftySwift
//
//  Created by Agustin De Cabrera on 5/18/16.
//  Copyright © 2016 Agustín de Cabrera. All rights reserved.
//

import Foundation

// MARK: - NSThread

extension Thread {
    public func objectFromThreadDictionary<T: AnyObject>(_ key:NSCopying, defaultValue: @autoclosure () -> T) -> T {
        
        if let result = threadDictionary[key] as? T {
            return result
        } else {
            let newObject = defaultValue()
            threadDictionary[key] = newObject
            return newObject
        }
    }
    
    public class func objectFromThreadDictionary<T: AnyObject>(_ key:NSCopying, defaultValue: @autoclosure () -> T) -> T {
        return current.objectFromThreadDictionary(key, defaultValue: defaultValue)
    }
}
