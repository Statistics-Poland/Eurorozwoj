//
//  InfoScreenLabel.swift
//  GusGame
//
//  Created by Tomasz Lizer on 15/04/2018.
//  Copyright © 2018 Paweł Czerwiński. All rights reserved.
//

import UIKit


class ScrollLabel: UIScrollView {
    
    let label: UILabel = {
        let label: UILabel = UILabel()
        label.numberOfLines = 0
        label.backgroundColor = .clear
        
       return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }


    func initialize() {
        addSubview(label)
    }
    

    var text: String? {
        get { return label.text }
        set {
            label.text = newValue
            calculateContentSize()
        }
    }
    
    
    private func calculateContentSize() {
        label.preferredMaxLayoutWidth = bounds.width
        contentSize = label.intrinsicContentSize
    }
    
    private var layoutedFor: CGRect?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard label.frame != layoutedFor else { return }
        calculateContentSize()
        
        label.frame = CGRect(origin: CGPoint.zero, size: contentSize)
        layoutedFor = label.frame
    }
}

