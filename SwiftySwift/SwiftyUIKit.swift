//
//  SwiftyUIKit.swift
//  SwiftySwift
//
//  Created by Agustín de Cabrera on 10/27/15.
//  Copyright © 2015 Agustín de Cabrera. All rights reserved.
//

import UIKit

// MARK: - UIColor

extension UIColor {
    public typealias RGBA = (r: UInt, g: UInt, b: UInt, a: UInt)
    public convenience init(rgba: RGBA) {        
        self.init(
            red:   CGFloat(rgba.r)/255.0, 
            green: CGFloat(rgba.g)/255.0, 
            blue:  CGFloat(rgba.b)/255.0, 
            alpha: CGFloat(rgba.a)/255.0
        )
    }
    
    public typealias RGB = (r: UInt, g: UInt, b: UInt)
    public convenience init(rgb: RGB) {
        self.init(rgba: (rgb.r, rgb.g, rgb.b, 255))
    }
    
    public convenience init(hex: UInt64) {
        let r = UInt((hex & 0xff000000) >> 24)
        let g = UInt((hex & 0x00ff0000) >> 16)
        let b = UInt((hex & 0x0000ff00) >> 8)
        let a = UInt((hex & 0x000000ff))
        
        self.init(rgba: (r, g, b, a))
    }
    
    public class func randomColor() -> UIColor {
        let component = { CGFloat(drand48()) }
        return UIColor(red: component(), green: component(), blue: component(), alpha: 1.0)
    }
}

// MARK: - UIImage

extension UIImage {
    private static let imagesCache = NSCache()
    
    public class func cachedImage(contentsOfFile path: String) -> UIImage? {
        if let cached = imagesCache.objectForKey(path) as? UIImage {
            return cached
        }
        
        if let image = UIImage(contentsOfFile: path) {
            imagesCache.setObject(image, forKey: path)
            return image
        }
        
        return nil
    }
    
    public class func tiledImageNamed(name: String) -> UIImage? {
        return self.init(named: name)?.resizableImageWithCapInsets(UIEdgeInsetsZero)
    }
    
    public class func imageByRenderingView(view: UIView) -> UIImage {
        let oldAlpha = view.alpha
        view.alpha = 1
        let image = imageByRenderingLayer(view.layer)
        view.alpha = oldAlpha
        
        return image
    }
    
    public class func imageByRenderingLayer(layer: CALayer) -> UIImage {
        UIGraphicsBeginImageContext(layer.bounds.size)
        layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        
        return image
    }
    
    public class func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    public func imageWithOrientation(orientation: UIImageOrientation) -> UIImage? {
        if let cgImage = CGImage {
            return UIImage(CGImage: cgImage, scale: scale, orientation: orientation)
        } else if let ciImage = CIImage {
            return UIImage(CIImage: ciImage, scale: scale, orientation: orientation)
        } else {
            return nil
        }
    }
    
    public func verticallyMirroredImage() -> UIImage? {
        return imageWithOrientation(imageOrientation.verticallyMirrored)
    }
    
    public func horizontallyMirroredImage() -> UIImage? {
        return imageWithOrientation(imageOrientation.horizontallyMirrored)
    }
}

extension UIImageOrientation {
    public var verticallyMirrored: UIImageOrientation {
        switch (self) {
        case .Up:            return .DownMirrored;
        case .Down:          return .UpMirrored;
        case .Left:          return .LeftMirrored;
        case .Right:         return .RightMirrored;
        case .UpMirrored:    return .Down;
        case .DownMirrored:  return .Up;
        case .LeftMirrored:  return .Left;
        case .RightMirrored: return .Right;
        }
    }
    
    public var horizontallyMirrored: UIImageOrientation {
        switch (self) {
        case .Up:            return .UpMirrored;
        case .Down:          return .DownMirrored;
        case .Left:          return .RightMirrored;
        case .Right:         return .LeftMirrored;
        case .UpMirrored:    return .Up;
        case .DownMirrored:  return .Down;
        case .LeftMirrored:  return .Right;
        case .RightMirrored: return .Left;
        }
    }
}

// MARK: - UIImageView

extension UIImageView {
    public convenience init?(imageNamed name: String) {
        self.init(image: UIImage(named: name))
    }
    
    public var imageOrientation: UIImageOrientation? {
        get { return image?.imageOrientation }
        set { image = newValue.flatMap { image?.imageWithOrientation($0) } }
    }
    
    public func mirrorVertically() {
        image = image?.verticallyMirroredImage()
    }
    public func mirrorHorizontally() {
        image = image?.horizontallyMirroredImage()
    }
}

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

// MARK: - UITableView

extension UITableView {
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

// MARK: - UICollectionView

extension UICollectionView {
    public var collectionViewFlowLayout: UICollectionViewFlowLayout {
        get { return collectionViewLayout as! UICollectionViewFlowLayout }
        set { collectionViewLayout = newValue }
    }
    
    public func dequeueReusableCellForIndexPath<T: UICollectionViewCell>(indexPath: NSIndexPath!) -> T {
        return dequeueReusableCellWithReuseIdentifier(T.cellIdentifier, forIndexPath: indexPath) as! T
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


