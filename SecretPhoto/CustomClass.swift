//
//  CustomClass.swift
//  SecretPhoto
//
//  Created by kawahara keisuke on 2017/02/26.
//  Copyright © 2017年 kawahara keisuke. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class CustomButton: UIButton {
    
    // 角丸の半径(0で四角形)
    @IBInspectable var cornerRadius: CGFloat = 0.0
    
    // 枠
    @IBInspectable var borderColor: UIColor = UIColor.clear
    @IBInspectable var borderWidth: CGFloat = 0.0
    
    override func draw(_ rect: CGRect) {
        // 角丸
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = (cornerRadius > 0)
        
        // 枠線
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        
        super.draw(rect)
    }
    

}

class PaddingLabel: UILabel {
    
    @IBInspectable var padding: UIEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
    
    override func drawText(in rect: CGRect) {
        let newRect = UIEdgeInsetsInsetRect(rect, padding)
        super.drawText(in: newRect)
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        return contentSize
    }
    
}

class MyTextField: UITextField {
    
    open var padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}

class Color {
    class func imageWithColor(color: UIColor, size: CGSize = CGSize(width: 60, height: 60) )-> UIImage {
        let rect = CGRect(x:0, y:0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context!.setFillColor(color.cgColor);
        context!.fill(rect);
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext();
        
        return image!;
    }
}

class NavigationController: UINavigationController {
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return .portrait
    }
}
