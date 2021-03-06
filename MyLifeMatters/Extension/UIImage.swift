//
//  CropImage.swift
//  VISUALOGYX
//
//  Created by Luu Nguyen on 10/1/16.
//  Copyright © 2016 Lavamy. All rights reserved.
//

import UIKit

extension UIImage {
    
    func crop(to: CGSize) -> UIImage {
        var to = to
        
        if self.imageOrientation.rawValue == 0 || self.imageOrientation.rawValue == 1 {
            let t = to.width
            to.width = to.height
            to.height = t
        }
        
        var posX : CGFloat = 0.0
        var posY : CGFloat = 0.0
        let cropAspect : CGFloat = to.width / to.height
        
        var cropWidth : CGFloat = to.width
        var cropHeight : CGFloat = to.height
        
        if to.width > to.height { // landscape
            cropWidth = self.size.width
            cropHeight = self.size.width / cropAspect
            posY = (self.size.height - cropHeight) / 2
        } else {
            cropWidth = self.size.height * cropAspect
            cropHeight = self.size.height
            posX = (self.size.width - cropWidth) / 2
        }
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: cropWidth, height: cropHeight)
        
        var rectTransform : CGAffineTransform!
        switch (self.imageOrientation)
        {
        case .left:
            rectTransform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2)).translatedBy(x: 0, y: -self.size.height)
        case .right:
            rectTransform = CGAffineTransform(rotationAngle: -CGFloat(M_PI_2)).translatedBy(x: -self.size.width, y: 0)
        case .down:
            rectTransform = CGAffineTransform(rotationAngle: -CGFloat(M_PI)).translatedBy(x: -self.size.width, y: -self.size.height)
        default:
            rectTransform = CGAffineTransform.identity
        }
        
        rectTransform = rectTransform.scaledBy(x: self.scale, y: self.scale);
        
        let imageRef : CGImage = self.cgImage!.cropping(to: rect.applying(rectTransform))!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let cropped : UIImage = UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)
        
        return cropped
    }
    
    func merge(image: UIImage, alpha: CGFloat) -> UIImage {
        print("Merge 2 images ...")
        let size = self.size
        print("Size 1 = \(size), size 2 = \(image.size)")
        print("Scale 1 = \(self.scale), scale 2 = \(image.scale)")
        UIGraphicsBeginImageContextWithOptions(size, false, self.scale)
        draw(at: .zero)
        image.draw(at: .zero, blendMode: .normal, alpha: alpha)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result!
    }
    
    func resize(newSize: CGSize) -> UIImage {
        let imageScale = min(newSize.width / size.width, newSize.height / size.height)
        if imageScale >= 1 {
            return self
        }
        
        let aspectSize = CGSize(width: size.width * imageScale, height: size.height * imageScale)
        let hasAlpha = false
        
        UIGraphicsBeginImageContextWithOptions(aspectSize, !hasAlpha, scale)
        draw(in: CGRect(origin: .zero, size: aspectSize))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage!
    }
}
