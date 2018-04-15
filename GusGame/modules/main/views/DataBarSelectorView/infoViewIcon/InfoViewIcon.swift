//
//  InfoViewIcon.swift
//  GusGame
//
//  Created by Tomasz Lizer on 15/04/2018.
//  Copyright © 2018 Paweł Czerwiński. All rights reserved.
//

import UIKit

class InfoViewIcon: OpacityControl {
    
    let label: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.app.standard_21
        label.text = "i"
        label.textColor = .white
        label.textAlignment = NSTextAlignment.center
        
        return label
    }()
    
    override func initialize() {
        self.addSubview(label)
        setView()
        addLabelConstraints()
        
    }
    
    private func setView() {
        
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 3.0
    }
    
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 40, height: 40)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = bounds
        self.layer.cornerRadius = bounds.height / 2.0
    }
    
    private func addLabelConstraints() {
        
//        label.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        label.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//        label.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
//        label.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
//
//        label.setContentCompressionResistancePriority(UILayoutPriority.init(rawValue: 1000), for: .horizontal)
    }
    
}
