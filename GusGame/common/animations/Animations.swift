//
//  Animations.swift
//  GusGame
//
//  Created by Mateusz Orzoł on 15.04.2018.
//  Copyright © 2018 Paweł Czerwiński. All rights reserved.
//

import UIKit

public enum Animations {
    public static var shakeAnimation: CAAnimation {
        let translation = CAKeyframeAnimation(keyPath: "transform.translation.x");
        translation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        translation.values = [-15, 15, -10, 10, -5, 5, -3, 3, -2, 2, 0]


        let shakeGroup: CAAnimationGroup = CAAnimationGroup()
        shakeGroup.animations = [translation]
        shakeGroup.duration = 1.5
        
        return shakeGroup
    }
}
