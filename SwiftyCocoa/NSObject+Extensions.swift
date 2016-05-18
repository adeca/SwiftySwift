//
//  NSObject+Extensions.swift
//  SwiftySwift
//
//  Created by Agustin De Cabrera on 5/18/16.
//  Copyright © 2016 Agustín de Cabrera. All rights reserved.
//

import Foundation

// MARK: - NSObject

extension NSObject {
    public func performBlock(block: () -> Void) {
        block()
    }
    
    public func performAfterDelay(delay: NSTimeInterval, _ block: () -> Void) {
        dispatch_after(delay) { [weak self] in 
            self?.performBlock(block) 
        }
    }
    
    public func performInBackground(block: () -> Void) {
        dispatch_async(DISPATCH_QUEUE_PRIORITY_DEFAULT, block)
    }
    
    public func performInMainThread(block: () -> Void) {
        dispatch_async(block)
    }
    
    public var className: String {
        return self.dynamicType.className
    }
    public static var className: String {
        return stringFromClass(self)
    }
    
    public func attachObject(object: AnyObject) {
        objc_setAssociatedObject(self, unsafeAddressOf(object), object, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    public func detachObject(object: AnyObject) {
        objc_setAssociatedObject(self, unsafeAddressOf(object), nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
