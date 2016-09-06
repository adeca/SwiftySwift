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
    public class func fromStoryboard(named name: String, identifier: String) -> UIViewController? {
        return fromStoryboard(UIStoryboard(name: name, bundle: nil), identifier: identifier)
    }
    public class func fromStoryboard(_ storyboard: UIStoryboard, identifier: String) -> UIViewController? {
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }
    
    public class func fromStoryboard(named name: String) -> Self? {
        return fromStoryboard(UIStoryboard(name: name, bundle: nil))
    }
    public class func fromStoryboard(_ storyboard: UIStoryboard) -> Self? {
        return controllerFromStoryboard(storyboard)
    }
}

private func controllerFromStoryboard<T: UIViewController>(_ storyboard: UIStoryboard) -> T? {
    return T.fromStoryboard(storyboard, identifier: T.className) as? T
}
