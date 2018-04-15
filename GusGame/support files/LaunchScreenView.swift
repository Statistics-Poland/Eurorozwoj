//
//  LaunchScreenView.swift
//  GusGame
//
//  Created by Tomasz Lizer on 15/04/2018.
//  Copyright © 2018 Paweł Czerwiński. All rights reserved.
//

import UIKit

class LaunchScreenView: BasicView {
    
    let imageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.image =
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    override func initialize() {
        self.addSubview(imageView)
        
        addImageViewConstraints()
        
        
        
    }
    
    func addImageViewConstraints() {
        
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    }
    
}
