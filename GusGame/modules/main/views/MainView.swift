import UIKit
import ARKit


class MainView: BasicARView {
    
    private let playerView: PlayersView = {
        let playerView = PlayersView()
        playerView.isUserInteractionEnabled = false
        playerView.alpha = 0.0
        playerView.translatesAutoresizingMaskIntoConstraints = false
        return playerView
    }()
    
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

    private let dateSelecotrView: DataBarSelectorView = {
        let dateSelecotrView = DataBarSelectorView()
        dateSelecotrView.alpha = 0.0
        dateSelecotrView.backgroundColor = UIColor.app.white
        dateSelecotrView.isUserInteractionEnabled = false
        dateSelecotrView.translatesAutoresizingMaskIntoConstraints = false
        return dateSelecotrView
    }()

    
    
    override func initialize() {
        super.initialize()
        addSubview(playerView)
        addSubview(topLbl)
        addSubview(bottomBtn)
        addSubview(dateSelecotrView)
        
        setupPlayerViewConstraints()
        setUpTopLblConstraints()
        setUpBottomBtnConstraints()
        setupDataSelectorViewContrstraints()
    }
    
    func hidePlayerView() {
        playerView.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3) {
            self.dateSelecotrView.alpha = 0.0
            self.layoutIfNeeded()
        }
    }
    
    func showPlayers(players: [Player]) {
        playerView.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.3) {
            self.playerView.alpha = 1.0
            self.layoutIfNeeded()
        }
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
    
    func hideDataSelectorView() {
        dateSelecotrView.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3) {
            self.dateSelecotrView.alpha = 0.0
            self.layoutIfNeeded()
        }
    }
    
    func showDataSelectorView(datas: [Int: Bool]) {
        dateSelecotrView.isUserInteractionEnabled = true
        dateSelecotrView.setup(dates: datas)
        UIView.animate(withDuration: 0.3) {
            self.dateSelecotrView.alpha = 0.8
            self.layoutIfNeeded()
        }
    }
    
    private func setupPlayerViewConstraints() {
        playerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        playerView.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        playerView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        playerView.widthAnchor.constraint(equalToConstant: 192).isActive = true
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
    
    private func setupDataSelectorViewContrstraints() {
        dateSelecotrView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        dateSelecotrView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
