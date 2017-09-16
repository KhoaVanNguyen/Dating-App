//
//  Ad.swift
//  Dating App
//
//  Created by Khoa Nguyen on 9/17/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Ad {
    var address: String
    var description: String
    var title: String
    var image: String
    var lat: Double
    var long: Double
    var price: String
    var url: String
    
    init(data: JSON) {
        address = data["address"].stringValue
        description = data["description"].stringValue
        image = data["images"].stringValue
        lat = data["location"]["lat"].doubleValue
        long = data["location"]["lng"].doubleValue
        price = data["price"].stringValue
        url = data["url"].stringValue
        title = data["title"].stringValue
        
    }
}


//address:
//"Cư Xá Bùi Minh Trực, phường 5, Quận 8, Hồ Chí Minh"
//description:
//"Ở đây, món bánh canh chỉ 20k thôi mà thịt và kh..."
//images:
//"https://media.foody.vn/images/peicesss(1).JPG"
//location
//lat:
//"10.7374225"
//lng:
//"106.6571159"
//price:
//"20.000đ-35.000đ"
//title:
//"Bánh canh Princess"
//url:
//"http://www.foody.vn/ho-chi-minh/tra-sua-princess"
