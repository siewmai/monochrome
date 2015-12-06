//
//  CreateProfileTableViewController.swift
//  monochrome
//
//  Created by Siew Mai Chan on 06/12/2015.
//  Copyright © 2015 Siew Mai Chan. All rights reserved.
//

import UIKit
import SwiftValidator

class CreateProfileTableViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var nameField: MonoTextField!
    @IBOutlet weak var emailField: MonoTextField!
    @IBOutlet weak var locationField: MonoTextField!
    @IBOutlet weak var bikeAgeField: MonoTextField!
    @IBOutlet weak var bioTextView: MonoTextView!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var joinButton: MonoButton!
    
    let validator = Validator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    @IBAction func beginEditName(sender: MonoTextField) {
        sender.focusMe = true
        bikeAgeField.focusMe = false
        
        validator.registerField(nameField, rules: [RequiredRule(), MinLengthRule(length: 6)])
    }
    
    @IBAction func endEditName(sender: MonoTextField) {
        sender.focusMe = false
        
        validator.unregisterField(nameField)
    }
    
    
    @IBAction func changeName(sender: MonoTextField) {
        validator.validate { errors in
            if errors.count > 0 {
                self.nameField.invalid = true
            } else {
                self.nameField.invalid = false
            }
        }
        
        joinButton.enabled = !(nameField.invalid || emailField.invalid)
        joinButton.alpha = joinButton.enabled ? 1 : 0.8
    }
    
    @IBAction func beginEditEmail(sender: MonoTextField) {
        sender.focusMe = true
        bikeAgeField.focusMe = false
        
        validator.registerField(emailField, rules: [RequiredRule(), EmailRule()])
    }
    
    @IBAction func endEditEmail(sender: MonoTextField) {
        sender.focusMe = false
        
        validator.unregisterField(emailField)
    }
    
    @IBAction func changeEmail(sender: MonoTextField) {
        validator.validate { errors in
            if errors.count > 0 {
                self.emailField.invalid = true
            } else {
                self.emailField.invalid = false
            }
        }
        
        joinButton.enabled = !(nameField.invalid || emailField.invalid)
        joinButton.alpha = joinButton.enabled ? 1 : 0.8
    }
    
    @IBAction func beginEditLocation(sender: MonoTextField) {
        sender.focusMe = true
        bikeAgeField.focusMe = false
    }
    
    @IBAction func endEditLocation(sender: MonoTextField) {
        sender.focusMe = false
    }
    
    @IBAction func stepperTriggered(sender: UIStepper) {
        self.view.endEditing(true)
        bikeAgeField.focusMe = true
    }
    
    @IBAction func stepperValueChanged(sender: UIStepper) {
        let value = Int(sender.value)
        
        if value == 0 {
            bikeAgeField.text = ""
        } else if value == 1 {
            bikeAgeField.text = "1 year"
        } else {
            bikeAgeField.text = "\(value) years"
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textViewDidChange(textView: UITextView) {
        bioTextView.placeholderLabel.hidden = !textView.text.isEmpty
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        bikeAgeField.focusMe = false
        bioTextView.focusMe = true
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        bioTextView.focusMe = false
    }
    
    func dismissKeyboard(){
        self.view.endEditing(true)
    }
}
