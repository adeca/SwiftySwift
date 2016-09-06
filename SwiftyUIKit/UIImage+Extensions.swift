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
    private static let imagesCache = NSCache<NSString, UIImage>()
    
    public class func cachedImage(contentsOfFile path: String) -> UIImage? {
        let cacheKey = path as NSString
        if let cached = imagesCache.object(forKey: cacheKey) {
            return cached
        }
        
        if let image = UIImage(contentsOfFile: path) {
            imagesCache.setObject(image, forKey: cacheKey)
            return image
        }
        
        return nil
    }
    
    public class func tiledImage(named name: String) -> UIImage? {
        return self.init(named: name)?.resizableImage(withCapInsets: .zero)
    }
    
    public class func imageByRenderingView(_ view: UIView) -> UIImage {
        let oldAlpha = view.alpha
        view.alpha = 1
        let image = imageByRenderingLayer(view.layer)
        view.alpha = oldAlpha
        
        return image
    }
    
    //TODO: use context APIs
    
    public class func imageByRenderingLayer(_ layer: CALayer) -> UIImage {
        UIGraphicsBeginImageContext(layer.bounds.size)
        let context = UIGraphicsGetCurrentContext()!
        layer.render(in: context)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        
        return image
    }
    
    public class func image(withColor color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
    
    public func image(withOrientation orientation: UIImageOrientation) -> UIImage? {
        if let cgImage = self.cgImage {
            return UIImage(cgImage: cgImage, scale: scale, orientation: orientation)
        } else if let ciImage = self.ciImage {
            return UIImage(ciImage: ciImage, scale: scale, orientation: orientation)
        } else {
            return nil
        }
    }
    
    public func verticallyMirrored() -> UIImage? {
        return image(withOrientation: imageOrientation.verticallyMirrored)
    }
    
    public func horizontallyMirrored() -> UIImage? {
        return image(withOrientation: imageOrientation.horizontallyMirrored)
    }
}

// MARK: - UIImageOrientation

extension UIImageOrientation {
    public var verticallyMirrored: UIImageOrientation {
        switch (self) {
        case .up:            return .downMirrored;
        case .down:          return .upMirrored;
        case .left:          return .leftMirrored;
        case .right:         return .rightMirrored;
        case .upMirrored:    return .down;
        case .downMirrored:  return .up;
        case .leftMirrored:  return .left;
        case .rightMirrored: return .right;
        }
    }
    
    public var horizontallyMirrored: UIImageOrientation {
        switch (self) {
        case .up:            return .upMirrored;
        case .down:          return .downMirrored;
        case .left:          return .rightMirrored;
        case .right:         return .leftMirrored;
        case .upMirrored:    return .up;
        case .downMirrored:  return .down;
        case .leftMirrored:  return .right;
        case .rightMirrored: return .left;
        }
    }
}
