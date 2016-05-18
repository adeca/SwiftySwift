//
//  UITableView+Extensions.swift
//  SwiftySwift
//
//  Created by Agustin De Cabrera on 5/18/16.
//  Copyright © 2016 Agustín de Cabrera. All rights reserved.
//

import UIKit

// MARK: - UITableView

extension UITableView {
    public var numberOfRows: Int {
        return (0..<(numberOfSections)).reduce(0) {
            $0 + numberOfRowsInSection($1)
        }
    }
    
    public func insertSection(section: Int, withRowAnimation animation: UITableViewRowAnimation) {
        insertSections(NSIndexSet(index: section), withRowAnimation: animation)
    }
    public func deleteSection(section: Int, withRowAnimation animation: UITableViewRowAnimation) {
        deleteSections(NSIndexSet(index: section), withRowAnimation: animation)
    }
    public func reloadSection(section: Int, withRowAnimation animation: UITableViewRowAnimation) {
        reloadSections(NSIndexSet(index: section), withRowAnimation: animation)
    }
    
    public func dequeueReusableCell<T: UITableViewCell>() -> T? {
        return dequeueReusableCellWithIdentifier(T.cellIdentifier) as? T
    }
    
    public func dequeueReusableCellForIndexPath<T: UITableViewCell>(indexPath: NSIndexPath) -> T {
        return dequeueReusableCellWithIdentifier(T.cellIdentifier, forIndexPath: indexPath) as! T
    }
    
    public func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T? {
        return dequeueReusableHeaderFooterViewWithIdentifier(T.defaultIdentifier) as? T
    }
}

// MARK: - UITableViewCell

extension UITableViewCell {
    public static var cellIdentifier: String {
        return className
    }
    
    public class func dequeueReusableCellFromTableView(tableView: UITableView) -> Self? {
        return tableView.dequeueReusableCell()
    }
    
    public class func dequeueReusableCellFromTableView(tableView: UITableView, indexPath: NSIndexPath) -> Self {
        return tableView.dequeueReusableCellForIndexPath(indexPath)
    }
}

// MARK: - UITableViewHeaderFooterView

extension UITableViewHeaderFooterView {
    public static var defaultIdentifier: String {
        return className
    }
    
    public class func dequeueFromTableView(tableView: UITableView) -> Self? {
        return tableView.dequeueReusableHeaderFooterView()
    }
    
    public class func registerNibInTableView(tableView: UITableView, bundle: NSBundle? = nil) {
        let nib = UINib(nibName: defaultIdentifier, bundle: bundle)
        tableView.registerNib(nib, forHeaderFooterViewReuseIdentifier: defaultIdentifier)
    }
}
