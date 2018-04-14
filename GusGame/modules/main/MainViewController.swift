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
    
    // MARK: - Outlets
    
    @IBOutlet var sceneView: ARSCNView!
    
    
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
        } else {
            dehighlight(country: country)
        }
    }
    
    
    // MARK: - Helpers
    
    private func highlight(country: Country) {
        guard let mapNode = sceneView.scene.rootNode.childNodes.first(where: { $0.name == NodeNames.map.rawValue }) else { return }
        guard let countryNode = mapNode.childNodes.first(where: { $0.name == country.rawValue }) else { return }
        defaultTransform = countryNode.transform
        let action = SCNAction.customAction(duration: 0.3) { (countryNode, _) in
            countryNode.transform = SCNMatrix4Scale(countryNode.transform, 1, 1.12, 1)
        }
        let moveActions = SCNAction.moveBy(x: 0.0, y: moveBy, z: 0, duration: 1)
        let actions = SCNAction.group([action, moveActions])
        countryNode.runAction(actions)
    }
    
    private func dehighlight(country: Country) {
        guard let mapNode = sceneView.scene.rootNode.childNodes.first(where: { $0.name == NodeNames.map.rawValue }) else { return }
        guard let countryNode = mapNode.childNodes.first(where: { $0.name == country.rawValue }) else { return }
        defaultTransform = countryNode.transform
        let action = SCNAction.customAction(duration: 0.3) { (countryNode, _) in
            countryNode.transform = SCNMatrix4Scale(countryNode.transform, 1, 0.889, 1)
        }
        let moveActions = SCNAction.moveBy(x: 0.0, y: -moveBy, z: 0, duration: 1)
        let actions = SCNAction.group([action, moveActions])
        countryNode.runAction(actions)
        defaultTransform = nil
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
    
    private func addEUMapTapGestureToSceneView() {
        let addEUMapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addMapToSceneView(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(addEUMapGestureRecognizer)
    }
    
    private func addSelectCountryTapGestureToSceneView() {
        let selectCountryGestrueRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectCountry(_:)))
        sceneView.addGestureRecognizer(selectCountryGestrueRecognizer)
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
