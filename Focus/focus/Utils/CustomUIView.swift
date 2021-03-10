import UIKit

@IBDesignable
class CustomUIView: UIView {
    
    @IBInspectable
    var color: UIColor = UIColor.black {
        didSet {
            layer.backgroundColor = color.cgColor
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get{
            return layer.cornerRadius
        }
        set{
            layer.cornerRadius = newValue
        }
    }
}
