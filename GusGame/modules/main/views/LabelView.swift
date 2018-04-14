import UIKit


class LabelView: BasicView {
    private let lbl: UILabel = {
        let lbl: UILabel = UILabel()
        lbl.font = UIFont.app.standard_21
        lbl.textAlignment = NSTextAlignment.center
        lbl.textColor = UIColor.app.black
        
        return lbl
    }()

    var text: String? {
        get { return lbl.text }
        set {
            lbl.text = newValue
            invalidateIntrinsicContentSize()
        }
    }
    
    
    override func initialize() {
        super.initialize()
        addSubview(lbl)
        
        backgroundColor = UIColor.app.white
        layer.cornerRadius = CGFloat(8.0)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        lbl.frame = bounds
    }
    
    override var intrinsicContentSize: CGSize {
        let lblS: CGSize = lbl.intrinsicContentSize
        return CGSize(width: lblS.width + CGFloat(16.0), height: lblS.height + CGFloat(8.0))
    }
}
