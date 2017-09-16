//
//  GradientView.swift
//  Smack
//
//  Created by Khoa Nguyen on 8/18/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: UIView {

    @IBInspectable var topColor: UIColor =  #colorLiteral(red: 0.3094600947, green: 0.6623311418, blue: 1, alpha: 1) {
        didSet{
            self.setNeedsLayout()
        }
    }
   
    @IBInspectable var bottomColor: UIColor = #colorLiteral(red: 0.09411764706, green: 0.9424949113, blue: 1, alpha: 1) {
        didSet{
            self.setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        let gradient = CAGradientLayer()
        gradient.colors = [topColor.cgColor,bottomColor.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.frame = self.bounds
//        self.layer.opacity = 0.9
        self.layer.insertSublayer(gradient, at: 0)
    }
}
