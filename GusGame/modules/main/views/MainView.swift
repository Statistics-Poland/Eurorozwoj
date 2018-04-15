import UIKit
import ARKit
import RxSwift


protocol MainViewDelegate: class {
    func mainView(didPressBtn view: MainView)
    func choose(date: Int, for nodeType: BarNodeType)
    func mainView(_ view: MainView, didPut workers: Int)
    func mainView(showInfo view: MainView)
}

class MainView: BasicARView {
    
    weak var gus_delegate: MainViewDelegate?
    
    private let disposeBag = DisposeBag()
    
    private let infoView: InfoView = {
        let playerView = InfoView()
        playerView.isUserInteractionEnabled = false
        playerView.alpha = 0.0
        playerView.translatesAutoresizingMaskIntoConstraints = false
        playerView.scrollLbl.text = instruction
        return playerView
    }()
    
    private let summaryView: SummaryView = {
        let playerView = SummaryView()
        playerView.isUserInteractionEnabled = false
        playerView.alpha = 0.0
        playerView.translatesAutoresizingMaskIntoConstraints = false
        return playerView
    }()
    
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
        workersView.translatesAutoresizingMaskIntoConstraints = false
        workersView.isUserInteractionEnabled = false
        workersView.alpha = CGFloat(0.0)
        return workersView
    }()
    
    
    private let info: InfoViewIcon = {
        let info: InfoViewIcon = InfoViewIcon()
        info.translatesAutoresizingMaskIntoConstraints = false
        return info
    }()

    
    
    override func initialize() {
        super.initialize()
        addSubview(playerView)
        addSubview(topLbl)
        addSubview(bottomBtn)
        addSubview(dateSelecotrView)
        addSubview(workersView)
        addSubview(summaryView)
        addSubview(infoView)
        addSubview(info)
            
        setupPlayerViewConstraints()
        setUpTopLblConstraints()
        setUpBottomBtnConstraints()
        setupDataSelectorViewContrstraints()
        setupWorkersViewContrstraints()
        setupWSummaryViewContrstraints()
        setupInfoViewContrstraints()
        setupnfoinconConstraints()
        
        bottomBtn.addTarget(self, action: #selector(btnHandler), for: UIControlEvents.touchUpInside)
        info.addTarget(self, action: #selector(showInfo), for: UIControlEvents.touchUpInside)
        workersView.delegate = self
    }
    
    
    func hideInfoView() {
        UIView.animate(withDuration: 0.3) {
            self.infoView.alpha = 0.0
            self.infoView.isUserInteractionEnabled = false
        }
    }
    
    func showInfoView() {
        UIView.animate(withDuration: 0.3) {
            self.infoView.alpha = 1.0
            self.infoView.isUserInteractionEnabled = true
        }
    }
    
    func hideSummary() {
        UIView.animate(withDuration: 0.3) {
            self.summaryView.alpha = 0.0
            self.summaryView.isUserInteractionEnabled = false
        }
    }
    
    func showSummary(players: [(Player, Int)]) {
        summaryView.setup(data: players)
        UIView.animate(withDuration: 0.3) {
            self.summaryView.alpha = 1.0
            self.summaryView.isUserInteractionEnabled = true
        }
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
    
    private func setupWSummaryViewContrstraints() {
        summaryView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        summaryView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        summaryView.heightAnchor.constraint(equalToConstant: 180).isActive = true
    }
    
    private func setupInfoViewContrstraints() {
        infoView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        infoView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        infoView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8).isActive = true
        infoView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8).isActive = true
    }
    
    
    private func setupnfoinconConstraints() {
        info.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
        info.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
    }
    
    
    @objc private func btnHandler() {
        print("klikłem")
        gus_delegate?.mainView(didPressBtn: self)
    }
    
    
    @objc private func showInfo() {
        gus_delegate?.mainView(showInfo: self)
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
