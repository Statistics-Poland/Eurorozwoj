//
//  DataBarSelectorView.swift
//  GusGame
//
//  Created by Mateusz Orzoł on 14.04.2018.
//  Copyright © 2018 Paweł Czerwiński. All rights reserved.
//

import UIKit

protocol DataBarSelectorViewDelegate: class {
    func choose(date: Int, for nodeType: BarNodeType)
}

class DataBarSelectorView: BasicView {
    
    weak var delegate: DataBarSelectorViewDelegate?
    private var nodeType: BarNodeType!
    
    private let stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var buttons: [TextControl] = (0..<3).map { (_) -> TextControl in
        let button = TextControl()
        let tap = UITapGestureRecognizer(target: self, action: #selector(buttonTapped(_:)))
        button.addGestureRecognizer(tap)
        button.backgroundColor = UIColor.app.blueLight
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true 
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    @objc private func buttonTapped(_ recognizer: UITapGestureRecognizer) {
        guard let button = recognizer.view as? TextControl else { return }
        guard let text = button.text else { return }
        guard let date = Int(text) else { return }
        delegate?.choose(date: date, for: nodeType)
    }
    
    func setup(dates: [Int: Bool], barNodeType: BarNodeType) {
        self.nodeType = barNodeType
        for (button, date) in zip(buttons, dates) {
            button.isEnabled = date.value
            button.backgroundColor = date.value ? UIColor.app.blueLight : UIColor.app.grayLight
            button.text = "\(date.key)"
        }
    }
    
    override func initialize() {
        super.initialize()
        for button in buttons {
            stackView.addArrangedSubview(button)
        }
        addSubview(stackView)
        backgroundColor = UIColor.app.white
        layer.cornerRadius = CGFloat(8.0)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            ])
    }
}
