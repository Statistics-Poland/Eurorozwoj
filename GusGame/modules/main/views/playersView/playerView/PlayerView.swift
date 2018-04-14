//
//  PlayerView.swift
//  GusGame
//
//  Created by Tomasz Lizer on 14/04/2018.
//  Copyright © 2018 Paweł Czerwiński. All rights reserved.
//

import UIKit

protocol PlayerViewDelegate: class{
    func playerView(didPressArrow: UIView)
}

class PlayerView: UIView {
    
    
    weak var delegate: PlayerViewDelegate?
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var playerWorkers: UILabel!
//    @IBOutlet weak var arrowIcon: UIImageView!{
//        didSet {
//            self.arrowIcon.image = UIImage(named: "arrowIcon")
//            arrowIcon.isHidden = true
//        }
//    }
    @IBOutlet weak var playerIcon: UIImageView! {
        didSet {
            self.playerIcon.image = UIImage(named: "playerIcon")
            self.playerIcon.image = self.playerIcon.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            self.playerIcon.tintColor = .red
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        playerIcon.backgroundColor = .clear
//        arrowIcon.backgroundColor = .clear
        playerName.backgroundColor = .clear
        playerWorkers.backgroundColor = .clear
        
       
        
//        addArrowGesture()
    }
    
//    private func addArrowGesture() {
//        let arrowTapGesture: UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(arrowTapAction))
//        self.arrowIcon.addGestureRecognizer(arrowTapGesture)
//    }
    
//    @objc private func arrowTapAction() {
//        delegate?.playerView(didPressArrow: self)
//    }
    

    
}
