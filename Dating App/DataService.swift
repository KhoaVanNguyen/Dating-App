//
//  DataService.swift
//  Dating App
//
//  Created by Khoa Nguyen on 9/16/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
//let DB_BASE = Database.database().reference()


let DB_BASE = FIRDatabase.database().reference()

class DataService {
    static let instance = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_GROUPS = DB_BASE.child("hashtags")
    
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    var REF_GROUPS: FIRDatabaseReference {
        return _REF_GROUPS
    }
 
    func createDBUser(uid: String, userData: Dictionary<String, Any>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
   
}
















