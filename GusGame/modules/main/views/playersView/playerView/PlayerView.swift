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
    @IBOutlet weak var playerIcon: UIImageView! {
        didSet {
            self.playerIcon.image = UIImage(named: "playerIcon")
            self.playerIcon.image = self.playerIcon.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            self.playerIcon.tintColor = .red
        }
    }
    
    func setup(player: Player) {
        playerName.text = player.name
        playerWorkers.text = "\(player.workers) | \(player.points)"
        playerIcon.tintColor = player.color
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        playerIcon.backgroundColor = .clear
        playerName.backgroundColor = .clear
        playerWorkers.backgroundColor = .clear
    }
}
