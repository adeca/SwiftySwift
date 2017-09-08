//
//  Dispatch+Extensions.swift
//  SwiftySwift
//
//  Created by Agustin De Cabrera on 5/18/16.
//  Copyright © 2016 Agustín de Cabrera. All rights reserved.
//

import Foundation

extension DispatchQueue {
    public func asyncAfter(delay: TimeInterval, 
                           qos: DispatchQoS = .unspecified, 
                           flags: DispatchWorkItemFlags = [], 
                           execute work: @escaping @convention(block) () -> Void) {
        asyncAfter(deadline: .now() + delay, qos: qos, flags: flags, execute: work)
    }
}

// MARK: - dispatch

/// Submits a block for asynchronous execution on a global queue with the given identifier
@available(*, deprecated)
public func async(qos: DispatchQoS.QoSClass, execute block: @escaping () -> Void) {
    DispatchQueue.global(qos: qos).async(execute: block)
}
/// Submits a block for asynchronous execution on the main queue
@available(*, deprecated)
public func async(execute block: @escaping ()->()) {
    DispatchQueue.main.async(execute: block)
}

/// Enqueue a block for execution on the main queue at the specified time (given in seconds)
@available(*, deprecated)
public func async(afterDelay delay: TimeInterval, qos: DispatchQoS.QoSClass, execute block: @escaping @convention(block) () -> Void) {
    DispatchQueue.global(qos: qos).asyncAfter(delay: delay, execute: block)
}
/// Enqueue a block for execution on the main queue at the specified time (given in seconds)
@available(*, deprecated)
public func asyncAfter(delay: TimeInterval, execute block: @escaping @convention(block) () -> Void) {
    DispatchQueue.main.asyncAfter(delay: delay, execute: block)
}

// MARK: Identity

extension DispatchQueue {
    /// Returns `true` if the receiver is the queue being executed.
    public func isCurrent() -> Bool {
        return identity == DispatchQueue.getCurrentIdentity()
    }
    
    private static let identityKey = DispatchSpecificKey<UnsafeMutableRawPointer>()
    
    private var identity: UnsafeMutableRawPointer {
        if let identity = getSpecific(key: DispatchQueue.identityKey) {
            return identity
        }
        
        let newIdentity = UnsafeMutableRawPointer(mutating: label)
        setSpecific(key: DispatchQueue.identityKey, value: newIdentity)
        return newIdentity
    }
    
    private static func getCurrentIdentity() -> UnsafeMutableRawPointer? {
        return DispatchQueue.getSpecific(key: DispatchQueue.identityKey)
    }
}
