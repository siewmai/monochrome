//
//  MessageService.swift
//  monochrome
//
//  Created by Siew Mai Chan on 06/12/2015.
//  Copyright © 2015 Siew Mai Chan. All rights reserved.
//

import Foundation
import UIKit

class MessageService {
    static let instance = MessageService()
    
    func showError(title: String?, message: String?, action: String?, view: UIViewController) {
        let alert = UIAlertController(title: title, message: message
            , preferredStyle: .Alert)
        let action = UIAlertAction(title: action ?? "Close", style: .Cancel, handler: nil)
        alert.addAction(action)
        
        view.presentViewController(alert, animated: true, completion: nil)
    }
    
    func showMessage(title: String?, message: String?, action: String?, view: UIViewController) {
        let alert = UIAlertController(title: title, message: message
            , preferredStyle: .Alert)
        let action = UIAlertAction(title: action ?? "Close", style: .Default, handler: nil)
        alert.addAction(action)
        
        view.presentViewController(alert, animated: true, completion: nil)
    }
}