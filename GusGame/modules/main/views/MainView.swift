import UIKit
import ARKit
import RxSwift


protocol MainViewDelegate: class {
    func mainView(didPressBtn view: MainView)
    func choose(date: Int, for nodeType: BarNodeType)
    func mainView(_ view: MainView, didPut workers: Int)
}

class MainView: BasicARView {
    
    weak var gus_delegate: MainViewDelegate?
    
    private let disposeBag = DisposeBag()
    
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

    private lazy var dateSelecotrView: DataBarSelectorView = {
        let dateSelecotrView = DataBarSelectorView()
        dateSelecotrView.alpha = 0.0
        dateSelecotrView.delegate = self
        dateSelecotrView.backgroundColor = UIColor.app.white
        dateSelecotrView.isUserInteractionEnabled = false
        dateSelecotrView.translatesAutoresizingMaskIntoConstraints = false
        return dateSelecotrView
    }()
    
    private let workersView: DelegateWorkersView = {
        () -> DelegateWorkersView in
        let workersView: DelegateWorkersView = DelegateWorkersView()
        
        workersView.isHidden = true
        return workersView
    }()
    
    
    override func initialize() {
        super.initialize()
        addSubview(playerView)
        addSubview(topLbl)
        addSubview(bottomBtn)
        addSubview(dateSelecotrView)
        addSubview(workersView)
        
        setupPlayerViewConstraints()
        setUpTopLblConstraints()
        setUpBottomBtnConstraints()
        setupDataSelectorViewContrstraints()
        setupWorkersViewContrstraints()
        
        bottomBtn.addTarget(self, action: #selector(btnHandler), for: UIControlEvents.touchUpInside)
        workersView.delegate = self
    }
    
    func hideWorkers() {
        UIView.animate(withDuration: 0.3) {
            self.workersView.alpha = 0.0
            self.workersView.isUserInteractionEnabled = false
        }
    }
    
    func showWorkers(player: Player) {
        workersView.display(player: player)
        UIView.animate(withDuration: 0.3) {
            self.workersView.alpha = 1.0
            self.workersView.isUserInteractionEnabled = true
        }
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
    
    func setup(players: Observable<[Player]>) {
        players.subscribe(onNext: { [weak self](players) in
            self?.playerView.setup(playerModels: players)
        }).disposed(by: disposeBag)
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
    
    func showDataSelectorView(datas: [Int: Bool], barNodeType: BarNodeType) {
        dateSelecotrView.isUserInteractionEnabled = true
        dateSelecotrView.setup(dates: datas, barNodeType: barNodeType)
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
        bottomBtn.widthAnchor.constraint(equalToConstant: CGFloat(260.0)).isActive = true
        bottomBtnBottom.isActive = true
    }
    
    private func setupDataSelectorViewContrstraints() {
        dateSelecotrView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        dateSelecotrView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    private func setupWorkersViewContrstraints() {
        workersView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        workersView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    @objc private func btnHandler() {
        print("klikłem")
        gus_delegate?.mainView(didPressBtn: self)
    }
    
    
    
}

extension MainView: DataBarSelectorViewDelegate {
    
    func choose(date: Int, for nodeType: BarNodeType) {
        gus_delegate?.choose(date: date, for: nodeType)
        hideDataSelectorView()
    }
}


extension MainView: DelegateWorkersViewDelegate {
    func delegateWorkersView(_ view: DelegateWorkersView, didPut workers: Int) {
        gus_delegate?.mainView(self, didPut: workers)
    }
}
