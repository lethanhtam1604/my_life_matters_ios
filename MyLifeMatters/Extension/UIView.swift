//
//  UIView.swift
//  MyLifeMatters
//
//  Created by Thanh-Tam Le on 11/25/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import UIKit

let tagBorderBottom = 10

extension UIView {
    // shot
    
    func snapshot() -> UIImage {
        let size = self.frame.size
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        UIGraphicsBeginImageContext(size)
        drawHierarchy(in: rect, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    // keyboard
    
    func addTapToDismiss() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss)))
    }
    
    func dismiss() {
        endEditing(true)
    }
}
