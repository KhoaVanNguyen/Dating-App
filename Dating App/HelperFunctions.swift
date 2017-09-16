//
//  HelperFunctions.swift
//  Dating App
//
//  Created by Khoa Nguyen on 9/16/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
extension String {
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}

func randomColor() -> UIColor{
    let red = CGFloat(arc4random()) / CGFloat(UInt32.max)
    let green = CGFloat(arc4random()) / CGFloat(UInt32.max)
    
    let blue = CGFloat(arc4random()) / CGFloat(UInt32.max)
    
    
    let randomColor = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1)
    
    return randomColor
}
func randomString(length: Int) -> String {
    
    let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let len = UInt32(letters.length)
    
    var randomString = ""
    
    for _ in 0 ..< length {
        let rand = arc4random_uniform(len)
        var nextChar = letters.character(at: Int(rand))
        randomString += NSString(characters: &nextChar, length: 1) as String
    }
    
    return randomString
}

func calculateDistanceBetween(firsLat: Double, firstLong: Double, secondLat: Double, secondLong: Double) -> String {
    
    let coordinate₀ = CLLocation(latitude: firsLat , longitude: firstLong)
    let coordinate₁ = CLLocation(latitude: secondLat, longitude: secondLong)
    
    let distanceInMeters = coordinate₀.distance(from: coordinate₁)
    
    let result = String(format: "%.2f", distanceInMeters/1000)
    
//    return distanceInMeters
    return result
}

