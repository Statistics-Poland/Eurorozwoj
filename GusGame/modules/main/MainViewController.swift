import UIKit
import SceneKit
import ARKit
import PromiseKit

class MainViewController: BasicViewController {
    
    
    // MARK: - Properties
    
    private var mapNode: SCNNode? {
        didSet {
        }
    }
    private let addEUMapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addMapToSceneView(withGestureRecognizer:)))
    private let selectCountryGestrueRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectCountry(_:)))
    
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
        let position = SCNVector3(x,y + 0.1,z)
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
        for country: Country in countries {
            print(country)
        }
    }

    
    // MARK: - Helpers

    private func addMap(at position: SCNVector3) {
        guard self.mapNode == nil else { return }
        let scendeEU = SCNScene(named: "art.scnassets/EUMap.dae")!
        let nodesEU = scendeEU.rootNode.childNodes
        let nodeEUMap = SCNNode()
        for nodeEU in nodesEU {
            nodeEUMap.addChildNode(nodeEU)
        }
        nodeEUMap.transform = SCNMatrix4Scale(SCNMatrix4Identity, 0.1, 0.1, 0.1)
        nodeEUMap.position = position
        self.mapNode = nodeEUMap
        sceneView.scene.rootNode.addChildNode(nodeEUMap)
        sceneView.removeGestureRecognizer(addEUMapGestureRecognizer)
        addSelectCountryTapGestureToSceneView()
    }
    
    private func addPlane(at planeAnchor: ARPlaneAnchor, to node: SCNNode) {
//        let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        let plane = SCNPlane(width: CGFloat(0.5), height: CGFloat(0.5))
        let planeNode = SCNNode(geometry: plane)
        planeNode.simdPosition = float3(planeAnchor.center.x, 0, planeAnchor.center.z)
        planeNode.eulerAngles.x = -.pi / 2
        planeNode.opacity = 0.25
        node.addChildNode(planeNode)
    }
    
    // MARK: - Setup Gestures
    
    private func addEUMapTapGestureToSceneView() {
        sceneView.addGestureRecognizer(addEUMapGestureRecognizer)
    }
    
    private func addSelectCountryTapGestureToSceneView() {
        sceneView.addGestureRecognizer(selectCountryGestrueRecognizer)
    }
}

extension MainViewController: ARSCNViewDelegate  {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
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
