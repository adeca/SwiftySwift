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
    
    public class func fromNib(named name: String) -> Self? {  
        let allObjects = Bundle.main.loadNibNamed(name, owner: nil, options: nil) ?? []
        return castFirst(allObjects)
    }
    
    public class func fromNib() -> Self? {
        return fromNib(named: className)
    }
    
    public func applyContainedViewConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        superview?.addConstraints(containedViewConstraints())
    }
    
    public func containedViewConstraints() -> [NSLayoutConstraint] {
        let views = ["self": self]
        let formats = ["V:|[self]|", "H:|[self]|"]
        
        return NSLayoutConstraint.constraints(withVisualFormats: formats, options: [], metrics: nil, views: views)
    }
    
    public func containedViewConstraints(withHeight height: CGFloat) -> [NSLayoutConstraint] {
        let views = ["self": self]
        let metrics = ["height": height]
        let formats = ["V:|[self(height)]", "H:|[self]|"]
        
        return NSLayoutConstraint.constraints(withVisualFormats: formats, options: [], metrics: metrics, views: views)
    }
}
