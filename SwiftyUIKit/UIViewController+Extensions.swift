//
//  UIViewController+Extensions.swift
//  SwiftySwift
//
//  Created by Agustin De Cabrera on 5/18/16.
//  Copyright © 2016 Agustín de Cabrera. All rights reserved.
//

import UIKit

// MARK: - UIViewController

extension UIViewController {
    public class func fromStoryboardNamed(name: String, identifier: String) -> UIViewController? {
        return fromStoryboard(UIStoryboard(name: name, bundle: nil), identifier: identifier)
    }
    public class func fromStoryboard(storyboard: UIStoryboard, identifier: String) -> UIViewController? {
        return storyboard.instantiateViewControllerWithIdentifier(identifier)
    }
    
    public class func fromStoryboardNamed(name: String) -> Self? {
        return fromStoryboard(UIStoryboard(name: name, bundle: nil))
    }
    public class func fromStoryboard(storyboard: UIStoryboard) -> Self? {
        return controllerFromStoryboard(storyboard)
    }
}

private func controllerFromStoryboard<T: UIViewController>(storyboard: UIStoryboard) -> T? {
    return T.fromStoryboard(storyboard, identifier: T.className) as? T
}
