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

        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil {
            view.hidden = true
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil {
            self.performSegueWithIdentifier(SEGUE_MAIN_CONTROLLER, sender: nil)
        }
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
                let fbtoken = FBSDKAccessToken.currentAccessToken().tokenString
                DataService.instance.REF_BASE.authWithOAuthProvider("facebook", token: fbtoken, withCompletionBlock: { error, authData in
                        if error != nil {
                            ActivityIndicatorService.instance.hide()
                            MessageService.instance.showError(nil, message: "Unable to connect Monochrome", action: "Close", view: self)
                        } else {
                            self.processLogin(fbtoken, authData: authData)
                        }
                })
            }
        }
    }
    
    func processLogin(fbtoken: String, authData: FAuthData) {
        DataService.instance.REF_PROFILES.childByAppendingPath(authData.uid).observeSingleEventOfType(.Value, withBlock: { snapshot in
            if snapshot.value is NSNull {
                self.createProfile(fbtoken, authData: authData)
            } else {
                NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: KEY_UID)
                self.performSegueWithIdentifier(SEGUE_MAIN_CONTROLLER, sender: nil)
                ActivityIndicatorService.instance.hide()
            }
        })
    }
    
    func createProfile(fbtoken: String, authData: FAuthData) {
        let uid = authData.uid
        let displayName = authData.providerData["displayName"] as! String
        let email = authData.providerData["email"] as! String
        var imageUrl = ""
        
        if let url = authData.providerData["profileImageURL"] as? String {
            imageUrl = url // 100x100 by default
        }
        
        let request = FBSDKGraphRequest(graphPath: "me/picture", parameters: ["fields": "url", "redirect": false, "type": "large"], tokenString: fbtoken, version: nil, HTTPMethod: "GET")
        
        request.startWithCompletionHandler { connection, result, error in
            if error == nil {
                if let data = result["data"] as? Dictionary<String, AnyObject> {
                    if let url = data["url"] as? String {
                        // Use 200x200 if succeed
                        imageUrl = url
                    }
                }
            }
            
            let profile = Profile(uid: uid, displayName: displayName, email: email, imageUrl: imageUrl)
            self.performSegueWithIdentifier("CreateProfile", sender: profile)
            ActivityIndicatorService.instance.hide()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "CreateProfile" {
            if let controller = segue.destinationViewController as? CreateProfileTableViewController {
                if let profile = sender as? Profile {
                    controller.profile = profile
                }
            }
        }
    }
}
