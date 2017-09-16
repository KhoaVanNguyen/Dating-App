//
//  Message.swift
//  Dating App
//
//  Created by Khoa Nguyen on 9/16/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import Foundation


struct Message {
    var id: String
    var senderName: String
    var senderId: String
    var recipientName: String
    var recipientId: String
    var text: String
    var fileUrl: String?
    var type: String
    
    init(key: String, data: [String:String]) {
        id = key
        senderName = data["senderName"] ?? ""
        senderId = data["senderId"] ?? ""
        recipientName = data["recipientName"] ?? ""
        recipientId = data["recipientId"] ?? ""
        text = data["text"] ?? ""
        fileUrl = data["fileUrl"] ?? ""
        type = data["MediaType"] ?? ""
    }
}
