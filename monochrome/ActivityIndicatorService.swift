//
//  ActivityIndicatorService.swift
//  monochrome
//
//  Created by Siew Mai Chan on 06/12/2015.
//  Copyright © 2015 Siew Mai Chan. All rights reserved.
//

import Foundation
import UIKit

class ActivityIndicatorService {
    static let instance = ActivityIndicatorService()
    
    var indicator = UIActivityIndicatorView()
    
    func show(view: UIView, ignoreInteraction: Bool) {
        if !indicator.isAnimating() {
            indicator.frame = CGRectMake(0, 0, 50, 50)
            indicator.activityIndicatorViewStyle = .Gray
            indicator.center = view.center
            indicator.hidesWhenStopped = true
            
            view.addSubview(indicator)
            indicator.startAnimating()
            
            if ignoreInteraction {
                UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            }
        }
    }
    
    func hide() {
        if indicator.isAnimating() {
            indicator.stopAnimating()
            indicator.removeFromSuperview()
            if UIApplication.sharedApplication().isIgnoringInteractionEvents() {
                 UIApplication.sharedApplication().endIgnoringInteractionEvents()
            }
        }
    }
}
