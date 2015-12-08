//
//  Profile.swift
//  monochrome
//
//  Created by Siew Mai Chan on 07/12/2015.
//  Copyright © 2015 Siew Mai Chan. All rights reserved.
//

import Foundation

class Profile {
    let provider = "facebook"
    
    private var _uid: String!
    private var _displayName: String!
    private var _email: String!
    private var _bikeAge: String!
    private var _bio: String!
    private var _city: String!
    private var _imageUrl: String!
    
    var uid: String {
        return _uid
    }
    
    var displayName: String {
        get {
            return _displayName
        }
        
        set {
            _displayName = newValue
        }
    }
    
    var email: String {
        get {
            return _email
        }
        
        set {
            _email = newValue
        }
    }
    
    var bikeAge: String {
        get {
            return _bikeAge
        }
        
        set {
            _bikeAge = newValue
        }
    }
    
    var bio: String {
        get {
            return _bio
        }
        
        set {
            _bio = newValue
        }
    }
    
    var city: String {
        get {
            return _city
        }
        
        set {
            _city = newValue
        }
    }
    
    var imageUrl: String {
        get {
            return _imageUrl
        }
        
        set {
            _imageUrl = newValue
        }
    }
    
    init(uid: String, displayName: String, email: String, imageUrl: String) {
        _uid = uid
        _displayName = displayName
        _email = email
        _imageUrl = imageUrl
    }
}