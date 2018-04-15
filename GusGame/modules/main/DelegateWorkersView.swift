import UIKit




protocol DelegateWorkersViewDelegate: class {
    func delegateWorkersView(_ view: DelegateWorkersView, didPut workers: Int)
}


class DelegateWorkersView: BasicView {
    weak var delegate: DelegateWorkersViewDelegate?
    
    private let picker: WorkersPicker = {
        let picker: WorkersPicker = WorkersPicker()
        
        return picker
    }()

    
    private let titleLbl: UILabel = {
        let titleLbl: UILabel = UILabel()
        
        titleLbl.textColor = UIColor.app.black
        titleLbl.text = "Deleguj pracowników"
        titleLbl.font = UIFont.app.standard_21
        titleLbl.textAlignment = NSTextAlignment.center
        
        return titleLbl
    }()
    
    private let workersLbl: UILabel = {
        let workersLbl: UILabel = UILabel()
        
        workersLbl.font = UIFont.app.standard_17
        workersLbl.text = "Posiadasz 100"
        workersLbl.textColor = UIColor.app.black
        workersLbl.textAlignment = NSTextAlignment.center
        
        return workersLbl
    }()
    private let btn: TextControl = {
        let btn: TextControl = TextControl()
        btn.text = "Potwierdź"
        
        return btn
    }()

    
    override func initialize() {
        super.initialize()
        
        addSubview(picker)
        addSubview(titleLbl)
        addSubview(workersLbl)
        
        addSubview(btn)
        btn.addTarget(self, action: #selector(btnAction), for: UIControlEvents.touchUpInside)
        
        layer.cornerRadius = CGFloat(8.0)
        backgroundColor = UIColor.app.grayLight
    }
    
    
    func display(player: Player) {
        workersLbl.text = "Posiadasz \(player.workers)"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLbl.frame = CGRect(
            x: CGFloat(8.0), y: CGFloat(12.0),
            width: bounds.width - CGFloat(16.0),
            height: titleLbl.font.lineHeight
        )
        
        workersLbl.frame = CGRect(
            x: CGFloat(8.0), y: titleLbl.frame.maxY + CGFloat(16.0),
            width: bounds.width - CGFloat(16.0),
            height: workersLbl.font.lineHeight
        )
        
        picker.frame = CGRect(
            x: CGFloat(0.0), y: workersLbl.frame.maxY,
            width: bounds.width, height: picker.intrinsicContentSize.height - CGFloat(32.0)
        )
        
        btn.frame = CGRect(
            x: CGFloat(8.0), y: picker.frame.maxY,
            width: bounds.width - CGFloat(16.0),
            height: btn.intrinsicContentSize.height
        )
    }
    
    
    override var intrinsicContentSize: CGSize {
        let pickerS: CGSize = picker.intrinsicContentSize
        let titleS: CGSize = titleLbl.intrinsicContentSize
        let workersS: CGSize = workersLbl.intrinsicContentSize
        let btnS: CGSize = btn.intrinsicContentSize
        
        var maxW: CGFloat = pickerS.width
        maxW = fmax(maxW, titleS.width + CGFloat(16.0))
        maxW = fmax(maxW, workersS.width + CGFloat(16.0))
        maxW = fmax(maxW, btnS.width + CGFloat(16.0))
        
        let height: CGFloat =
              CGFloat(12.0) +
              titleS.height +
              CGFloat(16.0) +
              workersS.height -
              CGFloat(16.0) +
              pickerS.height -
              CGFloat(16.0) +
              btnS.height +
              CGFloat(16.0)
        
              
        
        return CGSize(width: maxW, height: height)
    }
    
    
    @objc private func btnAction() {
        delegate?.delegateWorkersView(self, didPut: picker.calculateValue())
    }
}

    
