//
//  DataService.swift
//  monochrome
//
//  Created by Siew Mai Chan on 06/12/2015.
//  Copyright © 2015 Siew Mai Chan. All rights reserved.
//

import Foundation
import Firebase

class DataService {
    static let instance = DataService()
    
    private var _REF_BASE = Firebase(url: "\(FIREBASE_URL)")
    private var _REF_PROFILES = Firebase(url: "\(FIREBASE_URL)/profiles")
    private var _REF_IMAGES = Firebase(url: "\(FIREBASE_URL)/images")
    
    var REF_BASE: Firebase {
        return _REF_BASE
    }
    
    var REF_PROFILES: Firebase {
        return _REF_PROFILES
    }
    
    var REF_IMAGES: Firebase {
        return _REF_IMAGES
    }
    
    var TIMESTAMP: [NSObject : AnyObject] {
        return FirebaseServerValue.timestamp()
    }
}
