//
//  CreateProfileTableViewController.swift
//  monochrome
//
//  Created by Siew Mai Chan on 06/12/2015.
//  Copyright © 2015 Siew Mai Chan. All rights reserved.
//

import UIKit
import CoreLocation
import AlamofireImage
import SwiftValidator

class CreateProfileTableViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, CropViewControllerDelegate {
    
    var profile: Profile?
    
    @IBOutlet weak var nameField: MonoTextField!
    @IBOutlet weak var emailField: MonoTextField!
    @IBOutlet weak var cityField: MonoTextField!
    @IBOutlet weak var bikeAgeField: MonoTextField!
    @IBOutlet weak var bioTextView: MonoTextView!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var joinButton: MonoButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var getCityButton: UIButton!

    let validator = Validator()
    let imagePicker = UIImagePickerController()
    var selectedImage: UIImage!
    
    let navigate = UIImage(named: "navigate")
    let close = UIImage(named: "close-empty")
    let locationManager = CLLocationManager()
    var requestingCity = false
    var requestCitySuceeded = false
    
    // Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        loadFacebookProfileImage()
        nameField.text = profile?.displayName
        emailField.text = profile?.email
        
        imagePicker.delegate = self
        imagePicker.modalPresentationStyle = .FormSheet

        locationManager.delegate = self
        
        getCityButton.setImage(navigate, forState: .Normal)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SEGUE_CROP_IMAGE {
            if let controller = segue.destinationViewController.contentViewController as? CropViewController {
                if let image = sender as? UIImage {
                    controller.delegate = self
                    controller.image = image
                }
            }
        }
    }

    // Actions
    @IBAction func beginEditName(sender: MonoTextField) {
        sender.focusMe = true
        bikeAgeField.focusMe = false
        cityField.focusMe = false
        
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
        cityField.focusMe = false
        
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
    
    @IBAction func stepperTriggered(sender: UIStepper) {
        self.view.endEditing(true)
        cityField.focusMe = false
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
    
    @IBAction func changeImage(sender: UIButton) {
        let options = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let library = UIAlertAction(title: "Choose from library", style: UIAlertActionStyle.Default) { action in
            
            self.imagePicker.sourceType = .PhotoLibrary
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        }
        
        let takePhoto = UIAlertAction(title: "Take profile photo", style: UIAlertActionStyle.Default) { action in
            self.imagePicker.sourceType = .Camera
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        }
        
        if selectedImage != nil {
            let facebookImage = UIAlertAction(title: "Import from Facebook", style: UIAlertActionStyle.Default) { action in
                self.loadFacebookProfileImage()
                self.selectedImage = nil
            }
            options.addAction(facebookImage)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        
        options.addAction(library)
        options.addAction(takePhoto)
        options.addAction(cancel)
        
        options.modalPresentationStyle = .Popover
        
        let presentationController = options.popoverPresentationController
        presentationController?.sourceView = sender
        presentationController?.sourceRect = sender.bounds
        
        presentViewController(options, animated: true, completion: nil)
    }
    
    @IBAction func getCurrentCity(sender: AnyObject) {
        self.view.endEditing(true)
        bikeAgeField.focusMe = false
        cityField.focusMe = true
        
        if requestCitySuceeded {
            requestCitySuceeded = false
            getCityButton.setImage(self.navigate, forState: .Normal)
            cityField.text = ""
        } else {
            requestingCity = true
            locationManager.requestWhenInUseAuthorization()
            ActivityIndicatorService.instance.show(self.view)
            locationManager.requestLocation()
        }
    }
    
    @IBAction func join(sender: AnyObject) {
        if profile != nil {
            ActivityIndicatorService.instance.show(self.view)
            createProfile(profile!, image: profileImage.image) { uid in
                if uid != nil {
                    NSUserDefaults.standardUserDefaults().setValue(uid, forKey: KEY_UID)
                    self.performSegueWithIdentifier(SEGUE_MAIN_CONTROLLER, sender: nil)
                    ActivityIndicatorService.instance.hide()
                } else {
                    ActivityIndicatorService.instance.hide()
                    MessageService.instance.showError(nil, message: "An error occurred while creating account", action: "Close", view: self)
                }
            }
        }
    }
    
    // Delegates
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
        cityField.focusMe = false
        bioTextView.focusMe = true
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        bioTextView.focusMe = false
    }
    
    func locationManager(manager: CLLocationManager,
        didChangeAuthorizationStatus status: CLAuthorizationStatus) {
            if(requestingCity && status == CLAuthorizationStatus.AuthorizedWhenInUse){
                ActivityIndicatorService.instance.show(self.view)
                locationManager.requestLocation()
            }
    }
    
    func locationManagerShouldDisplayHeadingCalibration(manager: CLLocationManager) -> Bool {
        return true
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        failedToGetCity()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        print(locations)
        
        if locations.count > 0 {
            CLGeocoder().reverseGeocodeLocation(locations[0], completionHandler: { placemarks, error in
                if placemarks?.count > 0 {
                    let placemark = placemarks?.last
                    var city = ""
                    
                    if let locality = placemark?.locality {
                        city = locality
                    }
                    
                    if let country = placemark?.country {
                        city.appendContentsOf(", \(country)")
                    }
                    self.cityField.text = city
                    self.getCityButton.setImage(self.close, forState: .Normal)
                    self.requestingCity = false
                    self.requestCitySuceeded = true
                    ActivityIndicatorService.instance.hide()
                } else {
                    self.failedToGetCity()
                }
            })
        } else {
            failedToGetCity()
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImage = image
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        if selectedImage != nil {
            performSegueWithIdentifier(SEGUE_CROP_IMAGE, sender: selectedImage)
        }
    }
    
    func imageDidFinichCrop(image: UIImage) {
        profileImage.image = image.resize(200)
    }
    
    // Functions
    func dismissKeyboard(){
        self.view.endEditing(true)
    }

    func loadFacebookProfileImage() {
        if profile != nil {
            let url = NSURL(string: profile!.imageUrl)!
            let placeholderImage = UIImage(named: "person")!
            
            profileImage.af_setImageWithURL(url, placeholderImage: placeholderImage)
        }
    }
    
    func failedToGetCity() {
        ActivityIndicatorService.instance.hide()
        MessageService.instance.showMessage("Failed to get location", message: "Please try again later", action: "OK", view: self)
    }
    
    func createProfile(profile: Profile, image: UIImage?, completion: (uid: String?) -> Void) {
        let city = (cityField.text == nil) ? "" : cityField.text!
        let bio = bioTextView.text
        let bikeAge = Int(stepper.value)
        
        let data: Dictionary<String, AnyObject> = [
            "provider": profile.provider,
            "displayName": nameField.text!,
            "email": emailField.text!,
            "city": city,
            "bikeAge":bikeAge,
            "bio": bio
        ]
        
        DataService.instance.REF_PROFILES.childByAppendingPath(profile.uid).setValue(data) { error, ref in
            ActivityIndicatorService.instance.hide()
            if (error != nil) {
                completion(uid: nil)
            } else {
                if image != nil {
                    self.uploadProfileImage(ref.key, image: image!, completion: { imageKey in
                        ref.updateChildValues(["image": imageKey])
                        completion(uid: ref.key)
                    })
                } else {
                    completion(uid: ref.key)
                }
            }
        }
    }
    
    func uploadProfileImage(uid: String, image:UIImage, completion: (imageKey: String)-> Void) {
        let imageRef = DataService.instance.REF_IMAGES.childByAutoId()
        let imageData = UIImageJPEGRepresentation(image, 1)
        AmazonS3Service.instance.uploadImageData(imageData!, folderName: uid, fileName: imageRef.key, completion: { nsurl in
                imageRef.setValue(["url": nsurl.URLString, "owner": uid, "timestamp": DataService.instance.TIMESTAMP])
            completion(imageKey: imageRef.key)
        })
    }
}
