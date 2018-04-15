//
//  PositionView.swift
//  GusGame
//
//  Created by Tomasz Lizer on 15/04/2018.
//  Copyright © 2018 Paweł Czerwiński. All rights reserved.
//

import UIKit

class PositionView: BasicView {
    
    private let positionLbl: UILabel = {
        let positionLbl: UILabel = UILabel()
        positionLbl.translatesAutoresizingMaskIntoConstraints = false
        positionLbl.font = UIFont.app.standard_21
        
        positionLbl.text = "1"
        
        positionLbl.backgroundColor = .clear
        
        return positionLbl
    }()
    
    private let playerIcon: UIImageView = {
        let playerIcon: UIImageView = UIImageView()
        playerIcon.translatesAutoresizingMaskIntoConstraints = false
        playerIcon.image = UIImage.init(named: "playerIcon")
        playerIcon.image = playerIcon.image?.withRenderingMode(.alwaysTemplate)
        playerIcon.contentMode = .scaleAspectFit
        playerIcon.tintColor = .black
        
        playerIcon.backgroundColor = .clear
        
        return playerIcon
    }()
    
    private let playerNameLbl: UILabel = {
        let playerNameLbl: UILabel = UILabel()
        playerNameLbl.translatesAutoresizingMaskIntoConstraints = false
        playerNameLbl.textAlignment = .left
        
        playerNameLbl.text = "name tstdydyrdy"
        
        playerNameLbl.backgroundColor = .clear
        
        return playerNameLbl
    }()
    
    private let playerPointsLbl: UILabel = {
        let playerPointsLbl: UILabel = UILabel()
        playerPointsLbl.translatesAutoresizingMaskIntoConstraints = false
        playerPointsLbl.textAlignment = .right
        
        playerPointsLbl.text = "Player Points test"
        
        playerPointsLbl.backgroundColor = .clear
        
        return playerPointsLbl
    }()
    
    func setup (player: Player, position: Int) {
        let playerName = player.name
        let playerColor = player.color
        let playerPoints = player.points
        
        positionLbl.text = String(position)
        playerNameLbl.text = playerName
        playerPointsLbl.text = String(playerPoints)
        playerIcon.tintColor = playerColor
        
    }
    
    override func initialize() {
        self.addSubview(positionLbl)
        self.addSubview(playerIcon)
        self.addSubview(playerNameLbl)
        self.addSubview(playerPointsLbl)
        
        self.backgroundColor = .clear
        
//        debugColors()
        
        addPositionLblConstraints()
        addPlayerIconConstraints()
        addPlayerNameLblConstraints()
        addPPlayerPointsLblConstraints()
        
    }
    
    func debugColors() {
        positionLbl.backgroundColor = UIColor.blue
        playerIcon.backgroundColor = .green
        playerNameLbl.backgroundColor = .yellow
        playerPointsLbl.backgroundColor = .magenta
    }
    
    private func addPositionLblConstraints() {
        positionLbl.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        positionLbl.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        positionLbl.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor, constant: 8).isActive = true
        
        positionLbl.setContentCompressionResistancePriority(UILayoutPriority.init(rawValue: 1000), for: .horizontal)
        positionLbl.setContentHuggingPriority(UILayoutPriority.init(rawValue: 1000), for: .horizontal)
    }
    
    private func addPlayerIconConstraints() {
        playerIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        playerIcon.leadingAnchor.constraint(equalTo: positionLbl.trailingAnchor, constant: 12).isActive = true
        playerIcon.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor, constant: 8).isActive = true
        
        playerIcon.setContentHuggingPriority(UILayoutPriority.init(rawValue: 900), for: .horizontal)
        playerIcon.setContentCompressionResistancePriority(UILayoutPriority.init(rawValue: 900), for: .horizontal)
        
        playerIcon.widthAnchor.constraint(equalTo: playerIcon.heightAnchor, multiplier: 1.0).isActive = true
    }
    
    private func addPlayerNameLblConstraints() {
        playerNameLbl.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        playerNameLbl.leadingAnchor.constraint(equalTo: playerIcon.trailingAnchor, constant: 8).isActive = true
        playerNameLbl.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor, constant: 8).isActive = true
        
        playerNameLbl.setContentHuggingPriority(UILayoutPriority.init(rawValue: 500), for: .horizontal)
        playerNameLbl.setContentCompressionResistancePriority(UILayoutPriority.init(rawValue: 700), for: .horizontal)
    }
    
    private func addPPlayerPointsLblConstraints() {
        playerPointsLbl.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        playerPointsLbl.leadingAnchor.constraint(equalTo: playerNameLbl.trailingAnchor, constant: 8).isActive = true
        playerPointsLbl.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor, constant: 8).isActive = true
        playerPointsLbl.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        
        playerPointsLbl.setContentCompressionResistancePriority(UILayoutPriority.init(rawValue: 800), for: .horizontal)
        playerPointsLbl.setContentHuggingPriority(UILayoutPriority.init(rawValue: 1000), for: .horizontal)
    }
    
    
}



