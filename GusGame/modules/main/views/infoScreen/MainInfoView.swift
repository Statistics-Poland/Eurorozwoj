//
//  MainInfoView.swift
//  GusGame
//
//  Created by Tomasz Lizer on 15/04/2018.
//  Copyright © 2018 Paweł Czerwiński. All rights reserved.
//

import UIKit



class MainInfoView: BasicView {
    
    
    let infoView: InfoView = InfoView()
    
    let playerSummary: SummaryView = SummaryView()
    
    let players: PlayersView = PlayersView()
    
    override func initialize() {
        
        self.addSubview(players)
        
        self.addSubview(infoView)
        infoView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(playerSummary)
        playerSummary.translatesAutoresizingMaskIntoConstraints = false
        playerSummary.isHidden = true
        
        
        infoView.scrollLbl.text = R.string.game_tutorial_text^
        let infoHeight = self.frame.width * 0.75
        let infoWidth = self.frame.height * 0.6
        infoView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        infoView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        infoView.heightAnchor.constraint(equalToConstant: infoHeight).isActive = true
        infoView.widthAnchor.constraint(equalToConstant: infoWidth).isActive = true
        
        
        playerSummary.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        playerSummary.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        playerSummary.heightAnchor.constraint(equalToConstant: 200).isActive = true

        layoutIfNeeded()
        
        self.backgroundColor = .yellow
        
    }
    
    
}

