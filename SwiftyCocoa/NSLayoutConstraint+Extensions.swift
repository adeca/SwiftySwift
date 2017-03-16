//
//  NSLayoutConstraint+Extensions.swift
//  SwiftySwift
//
//  Created by Agustin De Cabrera on 5/18/16.
//  Copyright © 2016 Agustín de Cabrera. All rights reserved.
//

import Foundation

// MARK: - NSLayoutConstraint

extension NSLayoutConstraint {
    public class func constraints(withVisualFormats formats: [String], options opts: NSLayoutFormatOptions, metrics: [String : Any]?, views: [String : Any]) -> [NSLayoutConstraint] {
        return formats.flatMap {
            NSLayoutConstraint.constraints(withVisualFormat: $0, options: opts, metrics: metrics, views: views)
        }
    }
}
