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
public func async(_ priority: DispatchQueue.GlobalQueuePriority, execute block: @escaping () -> Void) {
    DispatchQueue.global(priority: priority).async(execute: block)
}
/// Submits a block for asynchronous execution on the main queue
public func async(execute block: @escaping ()->()) {
    DispatchQueue.main.async(execute: block)
}

/// Enqueue a block for execution on the main queue at the specified time (given in seconds)
public func asyncAfter(delay: TimeInterval, priority: DispatchQueue.GlobalQueuePriority, execute block: @escaping @convention(block) () -> Void) {
    DispatchQueue.global(priority: priority).asyncAfter(delay: delay, execute: block)
}
/// Enqueue a block for execution on the main queue at the specified time (given in seconds)
public func asyncAfter(delay: TimeInterval, execute block: @escaping @convention(block) () -> Void) {
    DispatchQueue.main.asyncAfter(delay: delay, execute: block)
}
