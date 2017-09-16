//
//  AdCell.swift
//  Dating App
//
//  Created by Khoa Nguyen on 9/17/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import UIKit
import SDWebImage
class AdCell: UITableViewCell {
    @IBOutlet weak var descriptionLbl: UILabel!

    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var imageLbl: CircleImage!
    @IBOutlet weak var numberLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

   
    func configureCell(ad: Ad, index: Int){
        titleLbl.text = ad.title
        imageLbl.sd_setImage(with: URL(string: ad.image ))
        descriptionLbl.text = ad.description
        numberLbl.text = "\(index)"
        
        let distance = calculateDistanceBetween(firsLat: DataService.instance.lat, firstLong: DataService.instance.lng, secondLat: ad.lat, secondLong: ad.long)
        
        distanceLbl.text = "\(distance) km"
        
    }

}
