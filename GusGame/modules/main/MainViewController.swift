
import UIKit
import SceneKit
import ARKit
import PromiseKit

class MainViewController: BasicViewController {
    
    // MARK: - Properties

//    let playersView: PlayersView = PlayersView()
    private var mapNode: SCNNode?
    private var elementsNodes: [SCNNode] = []
    private var plane: SCNNode?
    private var defaultTransform: SCNMatrix4?
    private let moveBy: CGFloat = 0.8
    
    private let barChartCreator = BarChartCreator()
    
    // MOVE TO VIEW MODEL
    
    private var barNodeTypes: [BarNodeType] = [BarNodeType(name: "1", value: 0.5, barHight: 1), BarNodeType(name: "2", value: 0.5, barHight: 1.3), BarNodeType(name: "3", value: 0.5, barHight: 2.0) ]
    
    // MARK: - Outlets
    
    @IBOutlet var sceneView: MainView!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.addSubview(playersView)
//        playersView.frame.origin = CGPoint(x: 10.0, y: 10.0)
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
        sceneView.showPlayers(players: [])
        addEUMapTapGestureToSceneView()
        
        ApiService.shared.getAllShityData().done {
            (table: [Table<Double>]) in
            print("ok")
        }.catch {
            (error: Error) in
            print(error)
        }
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
            if name.last == "_" {
                return Country(code: String(name.dropLast()))
                }
            return Country(code: name)
        }
        guard let country = countries.first else { return }
        if defaultTransform == nil {
            removeModels()
            highlight(country: country) { [weak self] in
                guard let barNodeTypes = self?.barNodeTypes else { return }
                guard let countryNode = self?.getNode(for: country) else { return }
                guard let mapNode = self?.getMapNode() else { return }
                self?.barChartCreator.addBars(barNodes: barNodeTypes, for: countryNode, to: mapNode)
            }
        } else {
            guard let mapNode = getMapNode() else { return }
            barChartCreator.removeBars(for: barNodeTypes, parentNode: mapNode)
            addSelectCountryTapGestureToSceneView()
            dehighlight(country: country) { [weak self] in
                self?.addModels()
            }
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
    
    private func addModels() {
        // POLAND
        guard let polandNode = getNode(for: Country.poland) else { return }
        var position = SCNVector3(x: polandNode.position.x, y: polandNode.position.y + 0.4, z: polandNode.position.z)
        var transform = SCNMatrix4Scale(SCNMatrix4Identity, 15, 15, 15)
        setModel(node: ElementModel.onion.getModel(), position: position, transform: transform)
        // SPAIN
        guard let spainNode = getNode(for: Country.spain) else { return }
        position = SCNVector3(x: spainNode.position.x, y: spainNode.position.y + 0.4, z: spainNode.position.z)
        transform = SCNMatrix4Scale(SCNMatrix4Identity, 0.1, 0.1, 0.1)
        setModel(node: ElementModel.guitar.getModel(), position: position, transform: transform)
        // GERMANY
        guard let germanyNode = getNode(for: Country.germany) else { return }
        position = SCNVector3(x: germanyNode.position.x, y: germanyNode.position.y + 0.4, z: germanyNode.position.z)
        transform = SCNMatrix4Scale(SCNMatrix4Identity, 0.1, 0.1, 0.1)
        setModel(node: ElementModel.car.getModel(), position: position, transform: transform)
        // Italy
        guard let italyNode = getNode(for: Country.italy) else { return }
        position = SCNVector3(x: italyNode.position.x, y: italyNode.position.y + 0.4, z: italyNode.position.z)
        transform = SCNMatrix4Scale(SCNMatrix4Identity, 0.5, 0.5, 0.5)
        setModel(node: ElementModel.pizza.getModel(), position: position, transform: transform)
        // Sweden
        guard let swedenNode = getNode(for: Country.sweden) else { return }
        position = SCNVector3(x: swedenNode.position.x, y: swedenNode.position.y + 0.4, z: swedenNode.position.z)
        transform = SCNMatrix4Scale(SCNMatrix4Identity, 0.19, 0.19, 0.19)
        setModel(node: ElementModel.ship.getModel(), position: position, transform: transform)
        // France
        guard let franceNode = getNode(for: Country.france) else { return }
        position = SCNVector3(x: franceNode.position.x, y: franceNode.position.y + 0.4, z: franceNode.position.z)
        transform = SCNMatrix4Scale(SCNMatrix4Identity, 0.009, 0.009, 0.009)
        setModel(node: ElementModel.eiffla.getModel(), position: position, transform: transform)
    }
    
    private func animateModel(node: SCNNode) {
        let moveActions = SCNAction.sequence([SCNAction.moveBy(x: 0, y: 0.3, z: 0, duration: 1), SCNAction.moveBy(x: 0, y: -0.3, z: 0, duration: 1)])
        let rotoateActions = SCNAction.rotateBy(x: 0, y:  -(CGFloat.pi / 2), z: 0, duration: 2)
        let actions = SCNAction.group([moveActions, rotoateActions])
        node.runAction(actions, completionHandler: { [weak self] in
            self?.animateModel(node: node)
        })
    }
    
    private func removeModels() {
        for node in elementsNodes {
            node.removeFromParentNode()
        }
        elementsNodes.removeAll()
    }
    
    private func setModel(node: SCNNode, position: SCNVector3, transform: SCNMatrix4) {
        guard let mapNode = getMapNode() else { return }
        node.transform = transform
        node.position = position
        self.elementsNodes.append(node)
        mapNode.addChildNode(node)
        animateModel(node: node)
    }
    
    private func setColor(for country: Country, color: UIColor) {
        guard let countryNode = getNode(for: country) else { return }
        countryNode.geometry?.firstMaterial?.diffuse.contents = color
    }
    
    private func highlight(country: Country, completion: (() -> ())?) {
        guard let countryNode = getNode(for: country) else { return }
        defaultTransform = countryNode.transform
        moveAndResize(node: countryNode, moveBy: moveBy, scaleBy: CGFloat(2), transform: countryNode.transform, completion: completion)
    }
    
    private func dehighlight(country: Country, completion: (() -> ())?) {
        guard let countryNode = getNode(for: country) else { return }
        guard let transform = defaultTransform else { return }
        moveAndResize(node: countryNode, moveBy: -moveBy, scaleBy: CGFloat(0.5), transform: transform, completion: completion)
        defaultTransform = nil
    }
    
    private func moveAndResize(node: SCNNode, moveBy: CGFloat, scaleBy: CGFloat, transform: SCNMatrix4, completion: (() -> ())?) {
        //        let action = SCNAction.customAction(duration: 0.3) { (node, _) in
        //            node.transform = SCNMatrix4Scale(transform, 1, scaleHeightBy, 1)
        //        }
        let scaleAction = SCNAction.scale(by: CGFloat(scaleBy), duration: 1)
        let moveActions = SCNAction.moveBy(x: 0.0, y: moveBy, z: 0, duration: 1)
        let actions = SCNAction.group([scaleAction, moveActions])
        node.runAction(actions, completionHandler: completion)
    }
    
    private func getNode(for country: Country) -> SCNNode? {
        guard let mapNode = getMapNode() else { return nil }
        return mapNode.childNodes.first(where: { $0.name == country.rawValue })
    }
    
    private func getMapNode() -> SCNNode? {
        return sceneView.scene.rootNode.childNodes.first(where: { $0.name == ElementModel.map.rawValue })
    }
    
    private func addMap(at position: SCNVector3) {
        guard self.mapNode == nil else { return }
        let nodeEUMap = ElementModel.map.getModel()
        nodeEUMap.transform = SCNMatrix4Scale(SCNMatrix4Identity, 0.08, 0.08, 0.08)
        nodeEUMap.position = position
        self.mapNode = nodeEUMap
        sceneView.scene.rootNode.addChildNode(nodeEUMap)
        plane?.removeFromParentNode()
        addSelectCountryTapGestureToSceneView()
        addModels()
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
