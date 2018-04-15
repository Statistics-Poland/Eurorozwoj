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
        label.textAlignment = NSTextAlignment.center
        
        return label
    }()
    
    override func initialize() {
        self.addSubview(label)
        setView()
        addLabelConstraints()
        
    }
    
    private func setView() {
        let height: CGFloat = 50
        self.layer.cornerRadius = height / 2.0
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 2.0
    }
    
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 50, height: 50)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = bounds
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
