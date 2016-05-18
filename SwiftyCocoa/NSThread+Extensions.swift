//
//  NSThread+Extensions.swift
//  SwiftySwift
//
//  Created by Agustin De Cabrera on 5/18/16.
//  Copyright © 2016 Agustín de Cabrera. All rights reserved.
//

import Foundation

// MARK: - NSThread

extension NSThread {
    public func objectFromThreadDictionary<T: AnyObject>(key:NSCopying, @autoclosure defaultValue: () -> T) -> T {
        
        if let result = threadDictionary[key] as? T {
            return result
        } else {
            let newObject = defaultValue()
            threadDictionary[key] = newObject
            return newObject
        }
    }
    
    public class func objectFromThreadDictionary<T: AnyObject>(key:NSCopying, @autoclosure defaultValue: () -> T) -> T {
        return currentThread().objectFromThreadDictionary(key, defaultValue: defaultValue)
    }
}
