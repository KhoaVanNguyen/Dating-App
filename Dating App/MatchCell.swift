//
//  MatchCell.swift
//  Dating App
//
//  Created by Khoa Nguyen on 9/17/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import UIKit

class MatchCell: UITableViewCell {

    @IBOutlet weak var containerView: GradientView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var tagNumberLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func configureCell(user: User)  {
        
        
        
        containerView.layer.cornerRadius = 45
        containerView.layer.masksToBounds = true
        
        usernameLbl.text = user.id
        tagNumberLbl.text = "\(user.matchTags)"
    }
    
}
