//
//  User.swift
//  monochrome
//
//  Created by Siew Mai Chan on 10/12/2015.
//  Copyright © 2015 Siew Mai Chan. All rights reserved.
//

import Foundation

class User {
    private var _uid: String!
    private var _displayName: String!
    private var _imageUrl: String?
    
    var uid: String {
        return _uid
    }
    
    var displayName: String {
        return _displayName
    }
    
    var imageUrl: String? {
        return _imageUrl
    }
    
    init(uid: String, displayName: String, imageUrl: String?) {
        _uid = uid
        _displayName = displayName
        _imageUrl = imageUrl
    }
}