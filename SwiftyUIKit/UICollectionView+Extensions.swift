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
    
    public var numberOfItems: Int {
        return (0..<numberOfSections).reduce(0) {
            $0 + self.numberOfItems(inSection: $1)
        }
    }
    
    public func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: T.cellIdentifier, for: indexPath) as! T
    }
    
    public func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind elementKind: String, forIndexPath indexPath: IndexPath) -> T {
        return dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: T.className, for: indexPath) as! T
    }
}

// MARK: - UICollectionViewCell

extension UICollectionViewCell {
    public static var cellIdentifier: String {
        return className
    }
    
    public class func dequeueReusableCell(fromCollectionView collectionView: UICollectionView, indexPath: IndexPath) -> Self {
        return collectionView.dequeueReusableCell(forIndexPath: indexPath)
    }
}
