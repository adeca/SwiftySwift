//
//  UIView+Extensions.swift
//  SwiftySwift
//
//  Created by Agustin De Cabrera on 5/18/16.
//  Copyright © 2016 Agustín de Cabrera. All rights reserved.
//

import UIKit

// MARK: - UIView

extension UIView {
    public func removeSubviews() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
    
    public class func fromNibNamed(name: String) -> Self? {  
        let bundle = NSBundle.mainBundle()
        let allObjects = bundle.loadNibNamed(name ?? className, owner: nil, options: nil) ?? []
        return castFirst(allObjects)
    }
    
    public class func fromNib() -> Self? {
        return fromNibNamed(className)
    }
    
    public func applyContainedViewConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        superview?.addConstraints(containedViewConstraints())
    }
    
    public func containedViewConstraints() -> [NSLayoutConstraint] {
        let views = ["self": self]
        let formats = ["V:|[self]|", "H:|[self]|"]
        
        return NSLayoutConstraint.constraintsWithVisualFormats(formats, options: [], metrics: nil, views: views)
    }
    
    public func containedViewConstraintsWithHeight(height: CGFloat) -> [NSLayoutConstraint] {
        let views = ["self": self]
        let metrics = ["height": height]
        let formats = ["V:|[self(height)]", "H:|[self]|"]
        
        return NSLayoutConstraint.constraintsWithVisualFormats(formats, options: [], metrics: metrics, views: views)
    }
}
