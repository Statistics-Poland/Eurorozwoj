import UIKit


class TextControl: OpacityControl {
    private let label: UILabel = UILabel()
    
    var font: UIFont! {
        get { return label.font }
        set {
            label.font = newValue
            invalidateIntrinsicContentSize()
        }
    }
    
    var text: String? {
        get { return label.text }
        set {
            label.text = newValue
            invalidateIntrinsicContentSize()
        }
    }
    
    var contentInsets: UIEdgeInsets = UIEdgeInsets(
        top: CGFloat(8.0), left: CGFloat(8.0), bottom: CGFloat(8.0), right: CGFloat(8.0)
    ) {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override func initialize() {
        super.initialize()
        addSubview(label)
        
        label.isUserInteractionEnabled = false
        label.textColor = UIColor.app.black
        label.textAlignment = NSTextAlignment.center
        
        backgroundColor = UIColor.app.white
        layer.cornerRadius = CGFloat(8.0)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let textW: CGFloat = bounds.width - contentInsets.left - contentInsets.right
        let textH: CGFloat = bounds.height - contentInsets.top - contentInsets.bottom
        label.frame = CGRect(
            x: contentInsets.left, y: contentInsets.top,
            width: textW, height: textH
        )
    }
    
    
    override var intrinsicContentSize: CGSize {
        let lblSize: CGSize = label.intrinsicContentSize
        let width: CGFloat = contentInsets.left + contentInsets.right + lblSize.width
        let height: CGFloat = contentInsets.top + contentInsets.bottom + lblSize.height
        return CGSize(width: width, height: height)
    }
    
}
