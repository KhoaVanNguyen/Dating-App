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
    private var _REF_HASHTAGS = DB_BASE.child("hashtags")
    
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    var REF_GROUPS: FIRDatabaseReference {
        return _REF_HASHTAGS
    }
 
    func createDBUser(uid: String, userData: Dictionary<String, Any>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func addNewHashTag(hashtag: String, completion: @escaping (Bool) -> Void ){

        
        
        DispatchQueue.main.async {

            self._REF_HASHTAGS.child(hashtag).updateChildValues([AuthService.instance.currentUid(): true])
            completion(true)
        }
        
        
    }
    
    func getAllHashTag(completion: @escaping ([HashTag]) -> Void ){
        _REF_HASHTAGS.observe(.value, with: { (snapshotData) in
            guard let snapshots = snapshotData.children.allObjects as? [FIRDataSnapshot] else{
                return
            }
            
            var hashtags = [HashTag]()
            for snap in snapshots{
                
                let hashtag = HashTag(content: snap.key)
                hashtags.append(hashtag)
            }
            
            completion(hashtags)
            
        })
    }
}
















