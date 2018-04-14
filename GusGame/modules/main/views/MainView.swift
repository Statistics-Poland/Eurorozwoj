import UIKit
import ARKit


class MainView: BasicARView {
    private let topLbl: LabelView = {
        let topLbl: LabelView = LabelView()
        topLbl.translatesAutoresizingMaskIntoConstraints = false
        topLbl.text = "Zaznacz Francję"
        
        return topLbl
    }()
    private var topLblY: NSLayoutConstraint!
    
    private let bottomBtn: TextControl = {
        let bottomBtn: TextControl = TextControl()
        
        bottomBtn.translatesAutoresizingMaskIntoConstraints = false
        bottomBtn.text = "Test"
        
        return bottomBtn
    }()
    private var bottomBtnBottom: NSLayoutConstraint!

    
    override func initialize() {
        super.initialize()
        addSubview(topLbl)
        addSubview(bottomBtn)
        
        
        setUpTopLblConstraints()
        
        setUpBottomBtnConstraints()
    }
    
    
    
    func hideTopLbl() {
        UIView.animate(withDuration: 0.3) {
            self.topLblY.constant = -self.topLbl.frame.height
            self.layoutIfNeeded()
        }
    }
    
    func showTopLbl(withText text: String) {
        topLbl.text = text
        UIView.animate(withDuration: 0.3) {
            self.topLblY.constant = CGFloat(12.0)
            self.layoutIfNeeded()
        }
    }
    
    
    func hideBottomBtn() {
        UIView.animate(withDuration: 0.3) {
            self.bottomBtnBottom.constant = self.bottomBtn.frame.height
            self.layoutIfNeeded()
        }
    }
    
    func showBottomBtn(withText text: String) {
        bottomBtn.text = text
        UIView.animate(withDuration: 0.3) {
            self.bottomBtnBottom.constant = CGFloat(-16.0)
            self.layoutIfNeeded()
        }
    }
    
    
    private func setUpTopLblConstraints() {
        topLbl.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        topLblY = topLbl.topAnchor.constraint(equalTo: topAnchor, constant: 12)
        topLblY.isActive = true
    }

    
    private func setUpBottomBtnConstraints() {
        bottomBtn.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        bottomBtnBottom = bottomBtn.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        bottomBtnBottom.isActive = true
    }
}
