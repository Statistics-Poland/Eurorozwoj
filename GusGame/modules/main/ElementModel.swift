//
//  ElementModel.swift
//  GusGame
//
//  Created by Mateusz Orzoł on 14.04.2018.
//  Copyright © 2018 Paweł Czerwiński. All rights reserved.
//

import Foundation
import ARKit

enum ElementModel: String {
    
    case map = "EUMap"
    case onion = "PL_"
    case car = "DE_"
    case guitar = "ES_"
    case pizza = "IT_"
    case ship = "SE_"
    case eiffla = "FR_"
    
    func getModel() -> SCNNode {
        let scene: SCNScene!
        switch self {
        case .map:
            scene = SCNScene(named: "art.scnassets/EUMap.dae")!
        case .car:
            scene = SCNScene(named: "art.scnassets/car.dae")!
        case .guitar:
            scene = SCNScene(named: "art.scnassets/guitar.dae")!
        case .onion:
            scene = SCNScene(named: "art.scnassets/onion.dae")!
        case .pizza:
            scene = SCNScene(named: "art.scnassets/pizza/pizzaa.dae")!
        case .ship:
            scene = SCNScene(named: "art.scnassets/ship/ship.dae")!
        case .eiffla:
            scene = SCNScene(named: "art.scnassets/eiffl/eiffel.dae")
        }
        let sceneNodes = scene.rootNode.childNodes
        let node = SCNNode()
        node.name = self.rawValue
        for sceneNode in sceneNodes {
            node.addChildNode(sceneNode)
        }
        return node
    }
}
