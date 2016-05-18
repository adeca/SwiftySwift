//
//  UIImageView+Extensions.swift
//  SwiftySwift
//
//  Created by Agustin De Cabrera on 5/18/16.
//  Copyright © 2016 Agustín de Cabrera. All rights reserved.
//

import UIKit

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
