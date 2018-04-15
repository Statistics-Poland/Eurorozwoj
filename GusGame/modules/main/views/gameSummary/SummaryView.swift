//
//  SummaryView.swift
//  GusGame
//
//  Created by Tomasz Lizer on 15/04/2018.
//  Copyright © 2018 Paweł Czerwiński. All rights reserved.
//

import UIKit

class SummaryView: BasicView {
    
    let summaryStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .clear
        stackView.distribution = .fillEqually
        
        
       return stackView
    }()
    
    let playersNo: Int = 4
    
    
    override func initialize() {
        viewSetup()
        
        self.addSubview(summaryStackView)
        
        for player in 1...playersNo { //for player in players??
            let positionView: PositionView = PositionView()
            positionView.translatesAutoresizingMaskIntoConstraints = false
//            positionView.setup() // na razie puste
            summaryStackView.addArrangedSubview(positionView)
        }
        
        addSummaryStackViewConstraints()
        
    }
    
    func addSummaryStackViewConstraints() {
        summaryStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        summaryStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        summaryStackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        summaryStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    func viewSetup() {
        self.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        self.layer.cornerRadius = 8.0
        self.clipsToBounds = true
    }
    
}

