//
//  URL+Extensions.swift
//  SwiftySwift
//
//  Copyright © 2017 Agustín de Cabrera. All rights reserved.
//

extension URL {
    public var resourceIsReachable: Bool {
        do {
            return try checkResourceIsReachable()
        } catch {
            return false
        }
    }
}
