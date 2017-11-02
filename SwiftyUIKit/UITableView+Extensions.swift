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
        return (0..<numberOfSections).reduce(0) {
            $0 + self.numberOfRows(inSection: $1)
        }
    }
    
    public var allIndexPaths: [IndexPath] {
        return (0..<numberOfSections).flatMap { section in
            (0..<numberOfRows(inSection: section)).map { row in
                IndexPath(row: row, section: section)
            }
        }
    }
    
    public func insertSection(_ section: Int, with animation: UITableViewRowAnimation) {
        insertSections(IndexSet(integer: section), with: animation)
    }
    public func deleteSection(_ section: Int, with animation: UITableViewRowAnimation) {
        deleteSections(IndexSet(integer: section), with: animation)
    }
    public func reloadSection(_ section: Int, with animation: UITableViewRowAnimation) {
        reloadSections(IndexSet(integer: section), with: animation)
    }
    
    public func dequeueReusableCell<T: UITableViewCell>() -> T? {
        return dequeueReusableCell(withIdentifier: T.cellIdentifier) as? T
    }
    
    public func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: T.cellIdentifier, for: indexPath) as! T
    }
    
    public func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T? {
        return self.dequeueReusableHeaderFooterView(withIdentifier: T.defaultIdentifier) as? T
    }
}

// MARK: - UITableViewCell

extension UITableViewCell {
    public static var cellIdentifier: String {
        return className
    }
    
    public class func dequeueReusableCell(fromTableView tableView: UITableView) -> Self? {
        return tableView.dequeueReusableCell()
    }
    
    public class func dequeueReusableCell(fromTableView tableView: UITableView, indexPath: IndexPath) -> Self {
        return tableView.dequeueReusableCell(forIndexPath: indexPath)
    }
}

// MARK: - UITableViewHeaderFooterView

extension UITableViewHeaderFooterView {
    public static var defaultIdentifier: String {
        return className
    }
    
    public class func dequeue(fromTableView tableView: UITableView) -> Self? {
        return tableView.dequeueReusableHeaderFooterView()
    }
    
    public class func registerNib(inTableView tableView: UITableView, bundle: Bundle? = nil) {
        let nib = UINib(nibName: defaultIdentifier, bundle: bundle)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: defaultIdentifier)
    }
}
