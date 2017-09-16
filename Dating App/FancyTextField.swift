//
//  FancyTextField.swift
//  wheretogo
//
//  Created by Khoa Nguyen on 8/26/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import UIKit

@IBDesignable
class FancyTextField: UITextField {
    
    @IBInspectable
    var cornerRadius: CGFloat = 5{
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    @IBInspectable
    var leftImage: UIImage?{
        didSet{
            updateView()
        }
    }
    
    @IBInspectable
    var borderColor: UIColor?{
        didSet{
            updateView()
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat = 1 {
        didSet{
            updateView()
        }
    }
    @IBInspectable
    var leftPadding: CGFloat = 5 {
        didSet{
            updateView()
        }
    }
    func updateView(){
        
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor?.cgColor
        if let image = leftImage{
            self.leftViewMode = .always
            
            let imageView = UIImageView(frame: CGRect(x: leftPadding, y: 0, width: 20, height: 20))
            
            
            imageView.image = image
            imageView.tintColor = self.tintColor
            
            let containViewWidth = leftPadding + 20
            
            let containView = UIView(frame: CGRect(x: 0, y: 0, width: containViewWidth, height: 20))
            
            containView.addSubview(imageView)
            self.leftView = containView
            
        }else {
            self.leftViewMode = .never
        }
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "User Name", attributes: [NSForegroundColorAttributeName: self.tintColor, NSFontAttributeName: self.font ?? "Helvetica" ])
    }
    

}
