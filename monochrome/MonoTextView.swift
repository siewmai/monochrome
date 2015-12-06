//
//  MonoTextView.swift
//  monochrome
//
//  Created by Siew Mai Chan on 07/12/2015.
//  Copyright © 2015 Siew Mai Chan. All rights reserved.
//

import UIKit

@IBDesignable class MonoTextView: UITextView {

    var border = CALayer()
    var placeholderLabel: UILabel = UILabel()
    
    @IBInspectable var icon: String? {
        didSet {
            if icon != nil {
                
                let leftViewFrame = CGRectMake(0, 0, FIELD_LEFT_PADDING, frame.height)
                let image = UIImage(named: icon!)
                let iconImageView = UIImageView(image: image)
                iconImageView.frame = CGRect(x: 0, y: 0, width: FIELD_ICON_DIMENSION, height: FIELD_ICON_DIMENSION)
                let leftView = UIView(frame: leftViewFrame)
                leftView.addSubview(iconImageView)
                
                addSubview(leftView)
                
                textContainerInset.left = 24
                textContainerInset.top = 3
            }
        }
    }
    
    @IBInspectable var placeholder: String? {
        didSet {
            if placeholder != nil {
                placeholderLabel.frame.origin = CGPointMake(FIELD_LEFT_PADDING, 3)
                placeholderLabel.textColor = COLOR_LIGHT
                placeholderLabel.font = font
                placeholderLabel.text = placeholder
                placeholderLabel.sizeToFit()
                placeholderLabel.hidden = !text.isEmpty
            }
        }
    }
    
    var focusMe: Bool = false {
        didSet {
            if focusMe {
                setFocusedState()
            } else {
                setNormalState()
            }
        }
    }
    
    override func awakeFromNib() {
        layer.addSublayer(border)
        layer.masksToBounds = true
        setNormalState()
        
        addSubview(placeholderLabel)
    }
    
    func setNormalState() {
        let width = CGFloat(0.5)
        border.borderColor = COLOR_LIGHT.CGColor
        border.frame = CGRect(x: 0, y: frame.size.height - width, width:  frame.size.width, height: frame.size.height)
        border.borderWidth = width
    }
    
    func setFocusedState() {
        let width = CGFloat(1.0)
        border.borderColor = COLOR_DARK.CGColor
        border.frame = CGRect(x: 0, y: frame.size.height - width, width:  frame.size.width, height: frame.size.height)
        border.borderWidth = width
    }
}
