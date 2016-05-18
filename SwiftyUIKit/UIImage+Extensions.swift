//
//  UIImage+Extensions.swift
//  SwiftySwift
//
//  Created by Agustin De Cabrera on 5/18/16.
//  Copyright © 2016 Agustín de Cabrera. All rights reserved.
//

import UIKit

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

// MARK: - UIImageOrientation

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
