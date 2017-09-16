
import UIKit
/**
 Custom UIView with shadow, rounded corner
 - Author: Khoa Nguyen
 
 */
@IBDesignable
class FancyView: UIView {

    /**
     Set up
     - Author: Khoa Nguyen
     
     */
    
    @IBInspectable
    var shadowColor: UIColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.cornerRadius = 5.0
    }

}
