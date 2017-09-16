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
    private var _REF_CONVERSATIONS = DB_BASE.child("conversations")
//    private var _REF_CONVERSATIONS = DB_BASE.child("conversations")
    
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    var REF_GROUPS: FIRDatabaseReference {
        return _REF_HASHTAGS
    }
    var REF_CONVERSATIONS: FIRDatabaseReference {
        return _REF_CONVERSATIONS
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
    
    func addNewConversation(recipientId: String, recipientName: String, message:String, completion: @escaping (String) -> Void ){
        
        let dict = [
           "sender": AuthService.instance.currentUid(),
           "recipient": recipientId
        ]
        
        let id = randomString(length: 8)
        _REF_CONVERSATIONS.child(id).updateChildValues(dict)
        completion(id)
        
    }
    
    
    func loadAllConversation(completion: @escaping ([Conversation]) -> Void  ){
        REF_CONVERSATIONS.observeSingleEvent(of: .childAdded, with: { (snapshotData) in
            print(snapshotData)
            
            var conversations = [Conversation]()
            if let snapshot = snapshotData.value as? [String:Any] {
                let conversation = Conversation(id: snapshotData.key, data: snapshot)
                conversations.append(conversation)
            }
            
            completion(conversations)
            
        })
        
    }
    
    
    func addMessage(toConversation id: String, text: String,senderName: String,senderId: String, recipientName: String, recipientId: String, completion: @escaping (Bool) -> Void ){
        
        let dict = [
        "text": text,
        "senderName": senderName,
        "senderId": senderId,
        "recipientName": recipientName,
        "recipientId":  recipientId
        ]
        REF_CONVERSATIONS.child(id).child("messages").childByAutoId().setValue(dict)
    }
    
    func loadMessage(inConversation id: String,completion: @escaping (Message) -> Void ){
        
        REF_CONVERSATIONS.child(id).child("messages").observe(.childAdded, with: { (snapshotData) in
            
            
            if let snapshot = snapshotData.value as? [String: String] {
                let message = Message(key: snapshotData.key, data: snapshot)
                completion(message)
            }
            
        })
        
    }
}
















