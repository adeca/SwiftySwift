//
//  SwiftyCocoa.swift
//  SwiftySwift
//
//  Created by Agustín de Cabrera on 10/20/15.
//  Copyright © 2015 Agustín de Cabrera. All rights reserved.
//

import Foundation

// MARK: - dispatch

/// Submits a block for asynchronous execution on a global queue with the given identifier
public func dispatch_async(identifier: Int, _ block: dispatch_block_t) {
    dispatch_async(dispatch_get_global_queue(identifier, 0), block)
}
/// Submits a block for asynchronous execution on the main queue
public func dispatch_async(block: dispatch_block_t) {
    dispatch_async(dispatch_get_main_queue(), block)
}

/// Enqueue a block for execution at the specified time (given in seconds)
public func dispatch_after(delay: NSTimeInterval, _ queue: dispatch_queue_t, _ block: dispatch_block_t) {
    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * NSTimeInterval(NSEC_PER_SEC)))
    dispatch_after(time, queue, block)
}
/// Enqueue a block for execution on the main queue at the specified time (given in seconds)
public func dispatch_after(delay: NSTimeInterval, _ block: dispatch_block_t) {
    dispatch_after(delay, dispatch_get_main_queue(), block)
}

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

// MARK: - NSLayoutConstraint

extension NSLayoutConstraint {
    class func constraintsWithVisualFormats(formats: [String], options opts: NSLayoutFormatOptions, metrics: [String : AnyObject]?, views: [String : AnyObject]) -> [NSLayoutConstraint] {
        return formats.flatMap {
            NSLayoutConstraint.constraintsWithVisualFormat($0, options: opts, metrics: metrics, views: views)
        }
    }
}

// MARK: NSDate

extension NSDate: Comparable {}

public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.isEqualToDate(rhs)
}

public func <(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == .OrderedAscending
}

// MARK: NSCoding

extension NSCoding {
    public func archive() -> NSData {
        return NSKeyedArchiver.archivedDataWithRootObject(self)
    }
}

extension NSData {
    public func unarchive() -> AnyObject? {
        return NSKeyedUnarchiver.unarchiveObjectWithData(self)
    }
    
    public func unarchive<T>() -> T? {
        return unarchive() as? T
    }
}
