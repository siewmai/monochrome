//
//  Extension.swift
//  monochrome
//
//  Created by Siew Mai Chan on 08/12/2015.
//  Copyright © 2015 Siew Mai Chan. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func crop(frame: CGRect, scale: CGFloat) -> UIImage {
        let screenScale = UIScreen.mainScreen().scale
        var mutableRect = frame
        mutableRect.origin.x *= screenScale
        mutableRect.origin.y *= screenScale
        mutableRect.size.width *= screenScale
        mutableRect.size.height *= screenScale
        let drawPoint = CGPointZero
        UIGraphicsBeginImageContextWithOptions(mutableRect.size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        CGContextTranslateCTM(context, -mutableRect.origin.x, -mutableRect.origin.y)
        CGContextScaleCTM(context, scale * screenScale, scale * screenScale)
        drawAtPoint(drawPoint)
        let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return croppedImage
    }
    
    func resize(newWidth: CGFloat) -> UIImage {
        let scale = newWidth / size.width
        let newHeight = size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
}

extension UIViewController {
    var contentViewController: UIViewController {
        if let navcon =  self as? UINavigationController {
            return navcon.visibleViewController!
        } else {
            return self
        }
    }
}
