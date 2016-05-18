//
//  UIGestureRecognizer+Extensions.swift
//  SwiftySwift
//
//  Created by Agustin De Cabrera on 5/18/16.
//  Copyright © 2016 Agustín de Cabrera. All rights reserved.
//

import UIKit

// MARK: - UIGestureRecognizer

extension UIGestureRecognizer {
    public func removeFromView() {
        view?.removeGestureRecognizer(self)
    }
    
    public func cancel() { 
        // used to clear pending gestures
        enabled = false
        enabled = true
    }
}

