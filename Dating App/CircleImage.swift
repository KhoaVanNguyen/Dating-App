//
//  CircleImage.swift
//  Elite Condos
//
//  Created by Khoa on 11/12/16.
//  Copyright © 2016 Khoa. All rights reserved.
//

import UIKit
/**
 Custom UIImageView with shadow, rounded corner
 - Author: Khoa Nguyen
 
 */
@IBDesignable
class CircleImage: UIImageView {
    /**
     Set up
     - Author: Khoa Nguyen
     
     */
    override func awakeFromNib() {
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
        layoutIfNeeded()
    }

}
