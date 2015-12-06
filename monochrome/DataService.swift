//
//  DataService.swift
//  monochrome
//
//  Created by Siew Mai Chan on 06/12/2015.
//  Copyright © 2015 Siew Mai Chan. All rights reserved.
//

import Foundation
import Firebase

let FIREBASE_URL = "https://mai-monochrome.firebaseio.com"

class DataService {
    static let instance = DataService()
    
    private var _REF_BASE = Firebase(url: "\(FIREBASE_URL)")
    
    var REF_BASE: Firebase {
        return _REF_BASE
    }
}
