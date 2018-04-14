//
//  float4x4 Extension.swift
//  GusGame
//
//  Created by Mateusz Orzoł on 14.04.2018.
//  Copyright © 2018 Paweł Czerwiński. All rights reserved.
//

import ARKit

extension float4x4 {
    var translation: float3 {
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }
}
