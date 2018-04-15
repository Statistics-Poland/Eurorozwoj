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
    
    func addBarInfos(datas: [(String, SCNNode)], maxHeight: Float, parentNode: SCNNode) {
        for (index, data) in datas.enumerated() {
            addBarInfo(text: data.0, node: data.1, maxHeight: maxHeight, parentNode: parentNode, color: colors[index])
        }
    }
    
    func removeBars(for barNodeTypes: [BarNodeType], parentNode: SCNNode) {
        for bar in barNodeTypes {
            removeBar(barNode: bar, parentNode: parentNode)
        }
        removeBarInfos(parentNode: parentNode)
    }
    
    func removeBarInfos(parentNode: SCNNode) {
        let hudNodes = parentNode.childNodes.filter({ $0.name == "HUD" })
        hudNodes.forEach({ $0.removeFromParentNode()})
    }
    
    func addBars(barNodes: [BarNodeType], for countryNode: SCNNode, to parentNode: SCNNode) {
        let position1 = SCNVector3(countryNode.position.x, countryNode.position.y + 0.3, countryNode.position.z)
        addBar(barNode: barNodes[0], at: position1, parentNode: parentNode)
        let position2 = SCNVector3(countryNode.position.x + 1, countryNode.position.y + 0.3, countryNode.position.z)
        addBar(barNode: barNodes[1], at: position2, parentNode: parentNode)
        let position3 = SCNVector3(countryNode.position.x - 1, countryNode.position.y + 0.3, countryNode.position.z)
        addBar(barNode: barNodes[2], at: position3, parentNode: parentNode)
    }
    
    // Helpers
    
    private func addBarInfo(text: String, node: SCNNode, maxHeight: Float, parentNode: SCNNode, color: UIColor) {
        let labelNode = SKLabelNode(text: text)
        labelNode.fontSize = 40
        labelNode.fontColor = color
        labelNode.fontName = UIFont.app.standard_17.fontName
        labelNode.position = CGPoint(x: 50, y: 50)
        
        let skScene = SKScene(size: CGSize(width: 100, height: 100))
        skScene.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        skScene.addChild(labelNode)
        
        let plane = SCNPlane(width: 1.0, height: 1.0)
        let material = SCNMaterial()
        material.lightingModel = SCNMaterial.LightingModel.constant
        material.isDoubleSided = true
        material.diffuse.contents = skScene
        plane.materials = [material]
        
        let hudNode = SCNNode(geometry: plane)
        hudNode.name = "HUD"
        hudNode.position = SCNVector3(x: node.position.x, y: node.position.y + 2.3, z: node.position.z)
        hudNode.rotation = SCNVector4(x: 1, y: 0, z: 0, w: 3.14159265)
        parentNode.addChildNode(hudNode)
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
    }
    
    private func removeBar(barNode: BarNodeType, parentNode: SCNNode) {
        guard let barNode = parentNode.childNodes.first(where: { $0.name == barNode.name }) else { return }
        barNode.removeFromParentNode()
    }
}
