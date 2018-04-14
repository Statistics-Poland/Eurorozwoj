//
//  PlayersView.swift
//  GusGame
//
//  Created by Tomasz Lizer on 14/04/2018.
//  Copyright © 2018 Paweł Czerwiński. All rights reserved.
//

import UIKit

fileprivate var swipeDownGesture: String = "swipeDownGesture"
fileprivate var arrowTapName: String = "arrowTapName"

class PlayersView: UIView {
    
    var players: [PlayerView] = []
    var playersNumber: Int = 4
    var width: CGFloat = 0 {
        didSet {
            self.frame.size = CGSize(width: width, height: height)
        }
    }
    var height: CGFloat = 0 {
        didSet {
            self.frame.size = CGSize(width: width, height: height)
        }
    }
    private let animationDuration: TimeInterval = 0.4
    var arrowIcon: UIImageView = UIImageView()
    var arrowView: UIView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    
    
    func initialize() {
        
        populatePlayers()
        setArrow()
        self.frame.size.height = self.height
        collapsePlayers(withDuration: 0.0)
        
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        self.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
        
        addGestures()
        
//        let gesture = UIGestureRecognizer()
//        gesture.
    }
    func populatePlayers() {
        for  playerNo in 1...playersNumber {
            let player: PlayerView = Bundle.main.loadNibNamed("PlayerView", owner: nil, options: nil)?.first as! PlayerView
            player.playerName.text = "player \(playerNo)"
            players.append(player)
            self.addSubview(player)
            player.frame.origin = CGPoint(x: 0.0, y: CGFloat(playerNo-1) * player.frame.height)
            width = player.frame.width
            height += player.frame.height
        }
    }
    func setArrow() {
        print("ustawiam arrow")
        arrowView.bounds.size.width = 20
        arrowView.bounds.size.height = 20
        arrowView.center.y = (players.last?.center.y)!
        arrowView.frame.origin.x = players[0].frame.width + 6
        
        arrowIcon.frame.size = arrowView.bounds.size
        arrowIcon.image = UIImage(named: "arrowIcon")
        arrowIcon.contentMode = .scaleAspectFit
        self.addSubview(arrowView)
        arrowView.addSubview(self.arrowIcon)
        width += arrowView.frame.width + 12
    }
    
    func addGestures () {
        let collapseSwipeGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(collapse))
        collapseSwipeGesture.direction = .up
//        collapseSwipeGesture.delegate = self
        self.addGestureRecognizer(collapseSwipeGesture)
        
        let expandSwipeGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(expandPlayers))
        expandSwipeGesture.direction = .down
        expandSwipeGesture.name = swipeDownGesture
        expandSwipeGesture.delegate = self
        self.addGestureRecognizer(expandSwipeGesture)
        
        let arrowTapGesture: UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(arrowExpandCollapse))
        arrowTapGesture.name = arrowTapName
        arrowTapGesture.delegate = self
        self.addGestureRecognizer(arrowTapGesture)
    }
    
    @objc func collapse () { collapsePlayers(withDuration: animationDuration) }
    
    @objc func collapsePlayers(withDuration duration: TimeInterval) {
        print("collapse animation")
        UIView.animate(withDuration: duration, delay: 0.0, options: [],
                       animations: {
                        self.arrowIcon.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi)
                        let yTravel:CGFloat = self.height / CGFloat(self.playersNumber) * CGFloat(self.playersNumber-1)
                        self.arrowView.transform = CGAffineTransform.init(translationX: 0.0, y: -yTravel)
                        self.frame.size.height = self.height/CGFloat(self.playersNumber)
                        },
                       completion: nil)
        
        for (index, player) in players.enumerated() {
            UIView.animate(withDuration: duration, delay: 0.0, options: [],
                           animations: {
                            player.transform = CGAffineTransform.init(translationX: 0.0, y: -CGFloat(index)*player.frame.height)
                            let currentPlayer = self.subviews.first as! PlayerView
                            if currentPlayer != player {
                                print(player)
                                player.alpha = 0.0 }
                            },
                           completion: nil)
        }
        
    }
    
    @objc func expandPlayers() {
        print("expand animation")
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: [],
                       animations: {
                        self.arrowIcon.transform = CGAffineTransform.identity
                        self.arrowView.transform = CGAffineTransform.identity
                        self.frame.size.height = self.height
                        },
                       completion: nil)
        for player in players {
            UIView.animate(withDuration: animationDuration, delay: 0.0, options: [],
                           animations: {
                            player.alpha = 1.0
                            player.transform = CGAffineTransform.identity
                            },
                           completion: nil)
        }
    }
    @objc func arrowExpandCollapse () {
        print("tapgesture Man")
        if players.last?.transform == CGAffineTransform.identity {
            collapsePlayers(withDuration: animationDuration)
        } else {
            expandPlayers()
        }
    }
   
    
}
extension PlayersView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.name == swipeDownGesture /*&& otherGestureRecognizer.name !=  arrowTapName*/ {
            return true
            } else {
            return false
        }
    }
}
