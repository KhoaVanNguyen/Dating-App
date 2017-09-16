
import UIKit


/**
 Custom UIButton with shadow, rounded corner
 - Author: Khoa Nguyen
 
 */
@IBDesignable
class FancyBtn: UIButton {
    /**
     Set up
     - Author: Khoa Nguyen
     
     */

    @IBInspectable
    var shadowColor: UIColor? {
        didSet{
            updateView()
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat = 5 {
        didSet{
            updateView()
        }
    }
    
    func updateView(){
//        layer.shadowColor = shadowColor?.cgColor
//        layer.shadowOpacity = 0.8
//        layer.shadowRadius = 5.0
//        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.cornerRadius = cornerRadius

    }

}
