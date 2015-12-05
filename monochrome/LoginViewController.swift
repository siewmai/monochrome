//
//  LoginViewController.swift
//  monochrome
//
//  Created by Siew Mai Chan on 06/12/2015.
//  Copyright © 2015 Siew Mai Chan. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
       // performSegueWithIdentifier("CreateProfile", sender: self)
        
    }
    
    @IBAction func connectWithFacebook(sender: AnyObject) {
        
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logInWithReadPermissions(["email", "public_profile", "user_friends"], fromViewController: self) { facebookResult, facebookErr in
            if facebookErr != nil {
                MessageService.instance.showError(nil, message: "Facebook login failed", action: "Close", view: self)
            } else if facebookResult.isCancelled {
                MessageService.instance.showMessage(nil, message: "Facebook login was cancelled", action: "Close", view: self)
            } else {
                ActivityIndicatorService.instance.show(self.view)
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                DataService.instance.REF_BASE.authWithOAuthProvider("facebook", token: accessToken, withCompletionBlock: { error, authData in
                        ActivityIndicatorService.instance.hide()
                        if error != nil {
                            MessageService.instance.showError(nil, message: "Unable to connect Monochrome", action: "Close", view: self)
                        } else {
                            MessageService.instance.showMessage(nil, message: "Logged In", action: "Close", view: self)
                        }
                })
            }
        }
    }
}
