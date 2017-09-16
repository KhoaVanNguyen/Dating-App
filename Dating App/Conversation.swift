//
//  Conversation.swift
//  Dating App
//
//  Created by Khoa Nguyen on 9/16/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import Foundation

struct Conversation {
    var id: String
    var sender: String
    var recipient: String
    
    init(id: String, data: [String:Any] ) {
        self.id = id
        self.sender = data["sender"] as! String 
        self.recipient = data["recipient"] as! String
    }
}
