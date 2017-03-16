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
    public func perform(_ block: () -> Void) {
        block()
    }
    
    public func performAfter(delay: TimeInterval, _ block: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(delay: delay) { [weak self] in 
            self?.perform(block) 
        }
    }
    
    public func performInBackground(_ block: @escaping () -> Void) {
        DispatchQueue.global(qos: .default).async(execute: block)
    }
    
    public func performInMainThread(_ block: @escaping () -> Void) {
        DispatchQueue.main.async(execute: block)
    }
    
    public var className: String {
        return type(of: self).className
    }
    public static var className: String {
        return stringFromClass(self)
    }
    
    public func attach(_ object: AnyObject) {
        objc_setAssociatedObject(self, Unmanaged.passUnretained(object).toOpaque(), object, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    public func detach(_ object: AnyObject) {
        objc_setAssociatedObject(self, Unmanaged.passUnretained(object).toOpaque(), nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
