//
//  HashTagCell.swift
//  Dating App
//
//  Created by Khoa Nguyen on 9/16/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import UIKit

class HashTagCell: UICollectionViewCell {
    
    @IBOutlet weak var containView: UIView!
    @IBOutlet weak var tagLabel: UILabel!
//    @IBOutlet weak var tagButton: FancyBtn!
    override func awakeFromNib() {
        
    }
    
    
    func configureCell(tag: String){
        let size: CGSize = tag.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 17.0)])
//        tagLabel.sizeThatFits(size)
        
        
        print(contentView.frame.height)
        
        tagLabel.layer.masksToBounds = true
        tagLabel.layer.cornerRadius = 20
        tagLabel.text = "#\(tag)"
        tagLabel.backgroundColor = randomColor()
        
        
//        contentView.layer.cornerRadius = size.height / 2
    }
    
    
}
