//
//  BarChartCreator.swift
//  GusGame
//
//  Created by Mateusz Orzoł on 14.04.2018.
//  Copyright © 2018 Paweł Czerwiński. All rights reserved.
//

import UIKit
import ARKit

class BarChartCreator {
    
    // Actions
    
    func removeBars(for barNodeTypes: [BarNodeType], parentNode: SCNNode) {
        for bar in barNodeTypes {
            removeBar(barNode: bar, parentNode: parentNode)
        }
        removeBarInfos(parentNode: parentNode)
       // addSelectCountryTapGestureToSceneView()
    }
    
    func addBars(barNodes: [BarNodeType], for countryNode: SCNNode, to parentNode: SCNNode) {
        let position1 = SCNVector3(countryNode.position.x, countryNode.position.y + 0.3, countryNode.position.z)
        addBar(barNode: barNodes[0], at: position1, parentNode: parentNode)
        let position2 = SCNVector3(countryNode.position.x + 1, countryNode.position.y + 0.3, countryNode.position.z)
        addBar(barNode: barNodes[1], at: position2, parentNode: parentNode)
        let position3 = SCNVector3(countryNode.position.x - 1, countryNode.position.y + 0.3, countryNode.position.z)
        addBar(barNode: barNodes[2], at: position3, parentNode: parentNode)
        //addSelectBarTapGestureToSceneView()
    }
    
    
    func addBarInfo(text: String, node: SCNNode, maxHeight: Float, parentNode: SCNNode) {
        let labelNode = SKLabelNode(text: text)
        labelNode.fontSize = 50
        labelNode.fontName = UIFont.app.standard_17.fontName
        labelNode.position = CGPoint(x: 50, y: 50)
        
        let skScene = SKScene(size: CGSize(width: 100, height: 100))
        skScene.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        skScene.addChild(labelNode)
        
        let plane = SCNPlane(width: 0.5, height: 0.5)
        let material = SCNMaterial()
        material.lightingModel = SCNMaterial.LightingModel.constant
        material.isDoubleSided = true
        material.diffuse.contents = skScene
        plane.materials = [material]
        
        let hudNode = SCNNode(geometry: plane)
        hudNode.name = "HUD"
        hudNode.position = SCNVector3(x: node.position.x, y: node.position.y + maxHeight, z: node.position.z)
        hudNode.rotation = SCNVector4(x: 1, y: 0, z: 0, w: 3.14159265)
        parentNode.addChildNode(hudNode)
    }
    
    
    // Helpers
    
    private func removeBarInfos(parentNode: SCNNode) {
        let hudNodes = parentNode.childNodes.filter({ $0.name == "HUD" })
        hudNodes.forEach({ $0.removeFromParentNode()})
    }

    private func addBar(barNode: BarNodeType, at position: SCNVector3, parentNode: SCNNode) {
        let box = SCNBox(width: 0.8, height: barNode.barHight, length: 0.8, chamferRadius: 0)
        box.firstMaterial?.diffuse.contents = barNode.color
        let boxNode = SCNNode(geometry: box)
        boxNode.pivot = SCNMatrix4MakeTranslation(0, -Float(barNode.barHight / 2), 0)
        boxNode.name = barNode.name
        boxNode.opacity = 1.0
        boxNode.position = position
        parentNode.addChildNode(boxNode)
//        addBarInfo(text: "hehe", node: boxNode, maxHeight: 2.4, parentNode: parentNode)
    }
    
    private func removeBar(barNode: BarNodeType, parentNode: SCNNode) {
        guard let barNode = parentNode.childNodes.first(where: { $0.name == barNode.name }) else { return }
        barNode.removeFromParentNode()
    }
}
