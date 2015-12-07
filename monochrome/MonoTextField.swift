//
//  MonoTextField.swift
//  monochrome
//
//  Created by Siew Mai Chan on 06/12/2015.
//  Copyright © 2015 Siew Mai Chan. All rights reserved.
//

import UIKit

@IBDesignable class MonoTextField: UITextField {

    var border = CALayer()
    let errorImage = UIImageView()
    
    @IBInspectable var errorIcon: String? {
        didSet {
            if errorIcon != nil {
                let image = UIImage(named: errorIcon!)
                errorImage.image = image
                errorImage.frame = CGRect(x: layer.frame.width - 17, y: 9, width: 12, height: 12)
                errorImage.hidden = true
                
                addSubview(errorImage)
            }
        }
    }
    
    @IBInspectable var icon: String? {
        didSet {
            if icon != nil {
                
                let leftViewFrame = CGRectMake(0, 0, FIELD_LEFT_PADDING, frame.height)
                let image = UIImage(named: icon!)
                let iconImageView = UIImageView(image: image)
                iconImageView.frame = CGRect(x: 0, y: (leftViewFrame.height - FIELD_ICON_DIMENSION) / 2, width: FIELD_ICON_DIMENSION, height: FIELD_ICON_DIMENSION)
                let leftView = UIView(frame: leftViewFrame)
                leftView.addSubview(iconImageView)
                
                self.leftView = leftView
                leftViewMode = .Always
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
    
    var invalid: Bool = false {
        didSet {
            if invalid {
                errorImage.hidden = false
            } else {
                errorImage.hidden = true
            }
        }
    }
    
    override func awakeFromNib() {
        layer.addSublayer(border)
        setNormalState()
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
