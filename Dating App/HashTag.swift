//
//  HashTag.swift
//  Dating App
//
//  Created by Khoa Nguyen on 9/16/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import Foundation

struct HashTag {
    
    var content: String
    var id: String
    
    init(content: String) {
        self.content = content
        self.id = randomString(length: 8)
    }
}
