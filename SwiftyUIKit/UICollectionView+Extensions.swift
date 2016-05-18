//
//  UICollectionView+Extensions.swift
//  SwiftySwift
//
//  Created by Agustin De Cabrera on 5/18/16.
//  Copyright © 2016 Agustín de Cabrera. All rights reserved.
//

import UIKit

// MARK: - UICollectionView

extension UICollectionView {
    public var collectionViewFlowLayout: UICollectionViewFlowLayout {
        get { return collectionViewLayout as! UICollectionViewFlowLayout }
        set { collectionViewLayout = newValue }
    }
    
    public func numberOfItems() -> Int {
        return (0..<(numberOfSections())).reduce(0) {
            $0 + numberOfItemsInSection($1)
        }
    }
    
    public func dequeueReusableCellForIndexPath<T: UICollectionViewCell>(indexPath: NSIndexPath!) -> T {
        return dequeueReusableCellWithReuseIdentifier(T.cellIdentifier, forIndexPath: indexPath) as! T
    }
    
    public func dequeueReusableSupplementaryViewOfKind<T: UICollectionReusableView>(elementKind: String, forIndexPath indexPath: NSIndexPath) -> T {
        return dequeueReusableSupplementaryViewOfKind(elementKind, withReuseIdentifier: T.className, forIndexPath: indexPath) as! T
    }
}

// MARK: - UICollectionViewCell

extension UICollectionViewCell {
    public static var cellIdentifier: String {
        return className
    }
    
    public class func dequeueReusableCellFromCollectionView(collectionView: UICollectionView, indexPath: NSIndexPath) -> Self {
        return collectionView.dequeueReusableCellForIndexPath(indexPath)
    }
}
