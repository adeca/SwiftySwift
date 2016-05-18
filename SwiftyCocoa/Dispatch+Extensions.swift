//
//  Dispatch+Extensions.swift
//  SwiftySwift
//
//  Created by Agustin De Cabrera on 5/18/16.
//  Copyright © 2016 Agustín de Cabrera. All rights reserved.
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
