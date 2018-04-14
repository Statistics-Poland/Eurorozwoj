import UIKit
import SceneKit
import ARKit
import PromiseKit

enum NodeNames: String {
    case map = "EUMap"
}

class MainViewController: BasicViewController {
    
    
    // MARK: - Properties
    
    private var mapNode: SCNNode? {
        didSet {
        }
    }
    private var plane: SCNNode?
    private var defaultTransform: SCNMatrix4?
    private let moveBy: CGFloat = 0.8
    
    // MOVE TO VIEW MODEL
    
    private var barNodeTypes: [BarNodeType] = [BarNodeType(name: "1", value: 0.5, barHight: 1), BarNodeType(name: "2", value: 0.5, barHight: 1.3), BarNodeType(name: "3", value: 0.5, barHight: 2.0) ]
    
    // MARK: - Outlets
    
    @IBOutlet var sceneView: MainView!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // PAWEL GOWNO POBIERANIE DANYCH XD
        //        ApiService.shared.getFishingData().done {
        //            (table: Table<Double>) in
        //            print(table.valueFor(country: Country.cyprus, year: 2015))
        //            }.catch {
        //                (error: Error) in
        //                print(error)
        //        }
        
        sceneView.delegate = self
        // USUNAC DO PREZENTACJI !!!
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.isUserInteractionEnabled = true
        addEUMapTapGestureToSceneView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Pause the view's session
        sceneView.session.pause()
    }
    
    
    // MARK: - Actions
    
    @objc private func addMapToSceneView(withGestureRecognizer recognizer: UIGestureRecognizer) {
        let tapLocation = recognizer.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
        guard let hitTestResult = hitTestResults.first else { return }
        let translation = hitTestResult.worldTransform.translation
        let x = translation.x
        let y = translation.y
        let z = translation.z
        let position = SCNVector3(x,y,z)
        addMap(at: position)
    }
    
    @objc private func selectCountry(_ recognizer: UITapGestureRecognizer) {
        let location: CGPoint = recognizer.location(in: sceneView)
        let objects: [SCNHitTestResult] = sceneView.hitTest(location, options: nil)
        let nodes: [SCNNode] = objects.map { $0.node }
        let countries: [Country] = nodes.compactMap { (node) -> Country? in
            guard let name: String = node.name else { return nil }
            return Country(code: name)
        }
        guard let country = countries.first else { return }
        if defaultTransform == nil {
            highlight(country: country)
            addBars(barNodes: barNodeTypes, to: country)
            
        } else {
            removeBars()
//            setColor(for: country, color: UIColor.app.pink)
            dehighlight(country: country)
        }
    }
    
    @objc private func selectBar(_ recognizer: UITapGestureRecognizer) {
        let location: CGPoint = recognizer.location(in: sceneView)
        let objects: [SCNHitTestResult] = sceneView.hitTest(location, options: nil)
        let nodes: [SCNNode] = objects.map { $0.node }
        let barName: [String] = nodes.compactMap { (node) -> String? in
            return node.name
        }
        guard let name = barName.first else { return }
        guard let barType = barNodeTypes.first(where: { $0.name == name}) else { return }
    }
    
    // MARK: - Helpers
    
    private func setColor(for country: Country, color: UIColor) {
        guard let countryNode = getNode(for: country) else { return }
        countryNode.geometry?.firstMaterial?.diffuse.contents = color
    }
    
//
//    private func addBarInfo(text: String, node: SCNNode, maxHeight: Float) {
//        guard let mapNode = getMapNode() else { return }
//        let labelNode = SKLabelNode(text: "Hello World")
//        labelNode.fontSize = 20
//        labelNode.fontName = "San Fransisco"
//        labelNode.position = CGPoint(x: CGFloat(node.position.x), y: CGFloat(node.position.z))
//        labelNode.zPosition = CGFloat(node.position.y + maxHeight)
//        let node = SCNNode(geometry: labelNode)
//        mapNode.addChildNode(node)
//    }
    
    private func addBars(barNodes: [BarNodeType], to country: Country) {
        guard let countryNode = getNode(for: country) else { return }
        let position1 = SCNVector3(countryNode.position.x, countryNode.position.y + 0.3, countryNode.position.z)
        addBar(barNode: barNodes[0], at: position1)
        let position2 = SCNVector3(countryNode.position.x + 1, countryNode.position.y + 0.3, countryNode.position.z)
        addBar(barNode: barNodes[1], at: position2)
        let position3 = SCNVector3(countryNode.position.x - 1, countryNode.position.y + 0.3, countryNode.position.z)
        addBar(barNode: barNodes[2], at: position3)
        //addSelectBarTapGestureToSceneView()
    }
    
    private func addBar(barNode: BarNodeType, at position: SCNVector3) {
        guard let mapNode = getMapNode() else { return }
        let box = SCNBox(width: 0.8, height: barNode.barHight, length: 0.8, chamferRadius: 0)
        box.firstMaterial?.diffuse.contents = barNode.color
        let boxNode = SCNNode(geometry: box)
        boxNode.pivot = SCNMatrix4MakeTranslation(0, -Float(barNode.barHight / 2), 0)
        boxNode.name = barNode.name
        boxNode.opacity = 1.0
        boxNode.position = position
        mapNode.addChildNode(boxNode)
    }
    
    private func removeBars() {
        for bar in barNodeTypes {
            removeBar(barNode: bar)
        }
        addSelectCountryTapGestureToSceneView()
    }
    
    private func removeBar(barNode: BarNodeType) {
        guard let mapNode = getMapNode() else { return }
        guard let barNode = mapNode.childNodes.first(where: { $0.name == barNode.name }) else { return }
        barNode.removeFromParentNode()
    }
    
    private func highlight(country: Country) {
        guard let countryNode = getNode(for: country) else { return }
        defaultTransform = countryNode.transform
        moveAndResize(node: countryNode, moveBy: moveBy, scaleBy: CGFloat(2), transform: countryNode.transform)
    }
    
    private func dehighlight(country: Country) {
        guard let countryNode = getNode(for: country) else { return }
        guard let transform = defaultTransform else { return }
        moveAndResize(node: countryNode, moveBy: -moveBy, scaleBy: CGFloat(0.5), transform: transform)
        defaultTransform = nil
    }
    
    private func moveAndResize(node: SCNNode, moveBy: CGFloat, scaleBy: CGFloat, transform: SCNMatrix4) {
//        let action = SCNAction.customAction(duration: 0.3) { (node, _) in
//            node.transform = SCNMatrix4Scale(transform, 1, scaleHeightBy, 1)
//        }
        let scaleAction = SCNAction.scale(by: CGFloat(scaleBy), duration: 1)
        let moveActions = SCNAction.moveBy(x: 0.0, y: moveBy, z: 0, duration: 1)
        let actions = SCNAction.group([scaleAction, moveActions])
        node.runAction(actions)
    }
    
    private func getNode(for country: Country) -> SCNNode? {
        guard let mapNode = getMapNode() else { return nil }
        return mapNode.childNodes.first(where: { $0.name == country.rawValue })
    }
    
    private func getMapNode() -> SCNNode? {
        return sceneView.scene.rootNode.childNodes.first(where: { $0.name == NodeNames.map.rawValue })
    }
    
    private func addMap(at position: SCNVector3) {
        guard self.mapNode == nil else { return }
        let scendeEU = SCNScene(named: "art.scnassets/EUMap.dae")!
        let nodesEU = scendeEU.rootNode.childNodes
        let nodeEUMap = SCNNode()
        nodeEUMap.name = NodeNames.map.rawValue
        for nodeEU in nodesEU {
            nodeEUMap.addChildNode(nodeEU)
        }
        nodeEUMap.transform = SCNMatrix4Scale(SCNMatrix4Identity, 0.08, 0.08, 0.08)
        nodeEUMap.position = position
        self.mapNode = nodeEUMap
        sceneView.scene.rootNode.addChildNode(nodeEUMap)
        plane?.removeFromParentNode()
        addSelectCountryTapGestureToSceneView()
    }
    
    private func addPlane(at planeAnchor: ARPlaneAnchor, to node: SCNNode) {
        let plane = SCNPlane(width: CGFloat(1), height: CGFloat(1))
        let planeNode = SCNNode(geometry: plane)
        planeNode.simdPosition = float3(planeAnchor.center.x, 0, planeAnchor.center.z)
        planeNode.eulerAngles.x = -.pi / 2
        planeNode.opacity = 0.25
        node.addChildNode(planeNode)
        self.plane = planeNode
    }
    
    // MARK: - Setup Gestures
    
    private func addGestures() {
        addEUMapTapGestureToSceneView()
        addSelectCountryTapGestureToSceneView()
        addSelectBarTapGestureToSceneView()
    }
    
    private func addEUMapTapGestureToSceneView() {
        let addEUMapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addMapToSceneView(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(addEUMapGestureRecognizer)
    }
    
    private func addSelectCountryTapGestureToSceneView() {
        let selectCountryGestrueRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectCountry(_:)))
        sceneView.addGestureRecognizer(selectCountryGestrueRecognizer)
    }
    
    private func addSelectBarTapGestureToSceneView() {
        let selectBarGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectBar(_:)))
        sceneView.addGestureRecognizer(selectBarGestureRecognizer)
    }
}

extension MainViewController: ARSCNViewDelegate  {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard plane == nil else { return }
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        guard mapNode == nil else { return }
        addPlane(at: planeAnchor, to: node)
    }
    
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
