//
//  AuthService.swift
//  Dating App
//
//  Created by Khoa Nguyen on 9/16/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
class AuthService {
    static let instance = AuthService()
    
    
    
    func currentUid() -> String{
        
        let currentUser = FIRAuth.auth()?.currentUser
        return (currentUser?.uid)!
        
    }
    
    func registerUser(withEmail email: String, andPassword password: String, gender: Int, userCreationComplete: @escaping (_ status: Bool, _ error: Error?) -> ()) {
        FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
            guard let user = user else {
                userCreationComplete(false, error)
                return
            }
            
            let userData = ["provider": user.providerID, "email": user.email, "gender": gender] as [String : Any]
            DataService.instance.createDBUser(uid: user.uid, userData: userData)
            userCreationComplete(true, nil)
        }
    }
    
    func loginUser(withEmail email: String, andPassword password: String, loginComplete: @escaping (_ status: Bool, _ error: Error?) -> ()) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                loginComplete(false, error)
                return
            }
            loginComplete(true, nil)
        }
    }
}
