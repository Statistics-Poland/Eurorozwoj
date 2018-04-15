//
//  InfoScrollView.swift
//  GusGame
//
//  Created by Tomasz Lizer on 15/04/2018.
//  Copyright © 2018 Paweł Czerwiński. All rights reserved.
//

import UIKit

class InfoView: BasicView {
    
    
    private let button: TextControl = {
        let button: TextControl = TextControl()
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(dismissView), for: UIControlEvents.touchUpInside)
        button.text = "OK"
        
        return button
    }()
    
    
     var scrollLbl: ScrollLabel = {
        let scrollLbl: ScrollLabel = ScrollLabel()
        scrollLbl.translatesAutoresizingMaskIntoConstraints = false
    
       return scrollLbl
    }()
    

    @objc func dismissView() {
        UIView.animate(withDuration: 0.3, delay: 0.1,
                       animations: {
                        self.alpha = 0.0
                        self.transform = CGAffineTransform(scaleX: 0.3, y: 0.3) },
                       completion: {_ in self.removeFromSuperview()})
        
//        UIView.animate(withDuration: 0.1, delay: 0.0, options: [UIViewAnimationOptions.curveEaseIn],
//                       animations: {
//                        self.transform = CGAffineTransform(scaleX: 1.01, y: 1.01)},
//                       completion: nil)
    }
    
    override func initialize() {
        super.initialize()
        self.addSubview(scrollLbl)
        self.addSubview(button)
        addButtonConstraints()
        addScrollLblConstraints()
        setView()
        popAnimation()
    }
    
    func setView() {
        self.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        self.layer.cornerRadius = 8
        self.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        self.alpha = 0.0
        self.isHidden = true
    }
    
    func addScrollLblConstraints () {
        
        scrollLbl.topAnchor.constraint(equalTo: self.topAnchor, constant: 16.0).isActive = true
        scrollLbl.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0).isActive = true
        scrollLbl.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0).isActive = true
        scrollLbl.bottomAnchor.constraint(equalTo: button.topAnchor).isActive = true
    }
    
    func addButtonConstraints () {

        button.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -6.0).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
    }
    
    func popAnimation() {
        self.isHidden = false
        UIView.animate(withDuration: 0.4, delay: 0.0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 2.5, options: [],
                       animations: {
                        self.transform = CGAffineTransform.identity
                        self.alpha = 1.0 }, completion: nil)
    }
    
}
