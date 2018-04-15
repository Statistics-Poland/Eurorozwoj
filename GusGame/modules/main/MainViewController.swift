
import UIKit
import SceneKit
import ARKit
import PromiseKit
import RxSwift


class MainViewController: BasicViewController, MainViewDelegate {
    
    // MARK: - Properties
    
    var mapNode: SCNNode?
    var elementsNodes: [SCNNode] = []
    var plane: SCNNode?
    var defaultTransform: SCNMatrix4?
    let moveBy: CGFloat = 0.8
    var lastRotation: CGFloat = 0
    
    var gestureBarRecognizer: UITapGestureRecognizer?
    var gestureSetMapRecognizer: UITapGestureRecognizer?
    var gestureSelectCountryRecognizer: UITapGestureRecognizer?
    
    
    // var inStartMode: Bool = true
    var inSelectCountry: Bool = false
    var turnEnd: Bool = false
    var isShowingData: Bool = false
    
    let barChartCreator = BarChartCreator()
    
    var gameManager: GameManager! {
        didSet {
            gameManager.delegate = self
            gameManager.start()
            sceneView.setup(players: gameManager.game.players)
        }
    }
    
    var selectedDatas: [Int: Double] = [:]
    var questionData: QuestionData?
    var barNodeTypes: [BarNodeType] = [] {
        didSet { gestureBarTypes = barNodeTypes }
    }
    var gestureBarTypes: [BarNodeType] = []
    
    // MARK: - Outlets
    
    @IBOutlet var sceneView: MainView! {
        didSet {
            sceneView.gus_delegate = self
        }
    }
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
        sceneView.isUserInteractionEnabled = true
        sceneView.showPlayers(players: [])
        addEUMapTapGestureToSceneView()
        sceneView.hideTopLbl()
        sceneView.hideBottomBtn()
        ApiService.shared.getAllShityData().done {
            (tables: [Table<Double>]) in
            self.gameManager = GameManager(dataSet: tables)
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
//    private var initialRotation: SCNMatrix4!
//    @objc func rotateMap(recognizer: UIRotationGestureRecognizer) {
//        if recognizer.state == .began {
//            initialRotation = mapNode?.transform
//        } else if recognizer.state == .changed {
//            mapNode?.transform = SCNMatrix4Rotate(initialRotation, Float(recognizer.rotation), 0, 1.0, 0)
//        } else if recognizer.state == .ended {
//        } else {
//            mapNode?.transform = initialRotation
//        }
//    }
    
    @objc  func addMapToSceneView(withGestureRecognizer recognizer: UIGestureRecognizer) {
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
    
    @objc  func selectCountry(_ recognizer: UITapGestureRecognizer) {
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
        if inSelectCountry {
            inSelectCountry = false
            gameManager.selected(country: country)
        } else {
            //            if defaultTransform == nil {
            //                removeModels()
            //                highlight(country: country) { [weak self] in
            //                    guard let barNodeTypes = self?.barNodeTypes else { return }
            //                    guard let countryNode = self?.getNode(for: country) else { return }
            //                    guard let mapNode = self?.getMapNode() else { return }
            //                    self?.barChartCreator.addBars(barNodes: barNodeTypes, for: countryNode, to: mapNode)
            //                }
            //            } else {
            //                guard let mapNode = getMapNode() else { return }
            //                barChartCreator.removeBars(for: barNodeTypes, parentNode: mapNode)
            //                addSelectCountryTapGestureToSceneView()
            //                dehighlight(country: country) { [weak self] in
            //                    self?.addModels()
            //                }
            //            }
        }
    }
    
    @objc  func selectBar(_ recognizer: UITapGestureRecognizer) {
        let location: CGPoint = recognizer.location(in: sceneView)
        let objects: [SCNHitTestResult] = sceneView.hitTest(location, options: nil)
        let nodes: [SCNNode] = objects.map { $0.node }
        let barName: [String] = nodes.compactMap { (node) -> String? in
            return node.name
        }
        guard let name = barName.first else { return }
        guard let barType = gestureBarTypes.first(where: { $0.name == name}) else { return }
        var datas: [Int: Bool] = [:]
        guard let quesitonData = questionData else { return }
        for year in quesitonData.years {
            if selectedDatas.contains(where: { $0.key == year }){
                datas[year] = false
            } else {
                datas[year] = true
            }
        }
        gestureBarTypes.remove(at: gestureBarTypes.index(where: { $0.name == name })!)
        sceneView.showDataSelectorView(datas: datas, barNodeType: barType)
    }
    
    // MARK: - Helpers
    var isActive: Bool = false
    func showActive(country: Country, barNodes: [BarNodeType]) {
        if !isActive {
            isActive = true
            guard let countryNode = getNode(for: country) else { fatalError() }
            guard let mapNode = getMapNode() else { fatalError() }
            removeModels()
            highlight(country: country) { [weak self] in
                self?.barChartCreator.addBars(barNodes: barNodes, for: countryNode, to: mapNode)
                self?.addBarInfosWithValues()
            }
            addSelectBarTapGestureToSceneView()
        }
        selectedDatas = [:]
        barNodeTypes = barNodes
    }
    
    func hideActive(country: Country) {
        guard let mapNode = getMapNode() else { return }
        barChartCreator.removeBars(for: barNodeTypes, parentNode: mapNode)
        dehighlight(country: country) { [weak self] in
            self?.addModels()
        }
    }
    
    func addBarInfosWithValues() {
        guard let mapNode = getMapNode() else { return }
        let datas: [(String, SCNNode)] = barNodeTypes.compactMap { (barType) -> ((String, SCNNode))? in
            guard let node = getNode(for: barType.name) else { return nil }
            return ("\(barType.value)", node)
        }
        barChartCreator.addBarInfos(datas: datas, maxHeight: Float(questionData!.maxValue), parentNode: mapNode)
    }
    
    func addBarInfosWithYears(data: [(Double, Int)]) {
        guard let mapNode = getMapNode() else { return }
        var datas: [(String, SCNNode)] = []
        for (indx, dat) in data.enumerated() {
            guard let node = getNode(for: "\(indx)") else { return }
            datas.append(("\(dat.1)", node))
        }
        barChartCreator.addBarInfos(datas: datas, maxHeight: Float(questionData!.maxValue), parentNode: mapNode)
    }
    
    func addModels() {
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
    
    func animateModel(node: SCNNode) {
        let moveActions = SCNAction.sequence([SCNAction.moveBy(x: 0, y: 0.3, z: 0, duration: 1), SCNAction.moveBy(x: 0, y: -0.3, z: 0, duration: 1)])
        let rotoateActions = SCNAction.rotateBy(x: 0, y:  -(CGFloat.pi / 2), z: 0, duration: 2)
        let actions = SCNAction.group([moveActions, rotoateActions])
        node.runAction(actions, completionHandler: { [weak self] in
            self?.animateModel(node: node)
        })
    }
    
    func removeModels() {
        for node in elementsNodes {
            node.removeFromParentNode()
        }
        elementsNodes.removeAll()
    }
    
    func setModel(node: SCNNode, position: SCNVector3, transform: SCNMatrix4) {
        guard let mapNode = getMapNode() else { return }
        node.transform = transform
        node.position = position
        self.elementsNodes.append(node)
        mapNode.addChildNode(node)
        animateModel(node: node)
    }
    
    func setColor(for country: Country, color: UIColor) {
        guard let countryNode = getNode(for: country) else { return }
        countryNode.geometry?.firstMaterial?.diffuse.contents = color
    }
    
    func highlight(country: Country, completion: (() -> ())?) {
        guard let countryNode = getNode(for: country) else { return }
        defaultTransform = countryNode.transform
        moveAndResize(node: countryNode, moveBy: moveBy, scaleBy: CGFloat(2), transform: countryNode.transform, completion: completion)
    }
    
    func dehighlight(country: Country, completion: (() -> ())?) {
        guard let countryNode = getNode(for: country) else { return }
        guard let transform = defaultTransform else { return }
        moveAndResize(node: countryNode, moveBy: -moveBy, scaleBy: CGFloat(0.5), transform: transform, completion: completion)
        defaultTransform = nil
    }
    
    func moveAndResize(node: SCNNode, moveBy: CGFloat, scaleBy: CGFloat, transform: SCNMatrix4, completion: (() -> ())?) {
        //        let action = SCNAction.customAction(duration: 0.3) { (node, _) in
        //            node.transform = SCNMatrix4Scale(transform, 1, scaleHeightBy, 1)
        //        }
        let scaleAction = SCNAction.scale(by: CGFloat(scaleBy), duration: 1)
        let moveActions = SCNAction.moveBy(x: 0.0, y: moveBy, z: 0, duration: 1)
        let actions = SCNAction.group([scaleAction, moveActions])
        node.runAction(actions, completionHandler: completion)
    }
    
    func getNode(for barNodeTypeName: String) -> SCNNode? {
        guard let mapNode = getMapNode() else { return nil }
        return mapNode.childNodes.first(where: { $0.name == barNodeTypeName })
    }
    
    func getNode(for country: Country) -> SCNNode? {
        guard let mapNode = getMapNode() else { return nil }
        return mapNode.childNodes.first(where: { $0.name == country.rawValue })
    }
    
    func getMapNode() -> SCNNode? {
        return sceneView.scene.rootNode.childNodes.first(where: { $0.name == ElementModel.map.rawValue })
    }
    
    func addMap(at position: SCNVector3) {
        guard self.mapNode == nil else { return }
        let nodeEUMap = ElementModel.map.getModel()
        nodeEUMap.transform = SCNMatrix4Scale(SCNMatrix4Identity, 0.08, 0.08, 0.08)
        nodeEUMap.position = position
        self.mapNode = nodeEUMap
        sceneView.scene.rootNode.addChildNode(nodeEUMap)
        plane?.removeFromParentNode()
        addSelectCountryTapGestureToSceneView()
        addModels()
        gameManager.mapWasPlaced()
      //  addRotateGestureToScenView()
    }
    
    func addPlane(at planeAnchor: ARPlaneAnchor, to node: SCNNode) {
        let plane = SCNPlane(width: CGFloat(1), height: CGFloat(1))
        let planeNode = SCNNode(geometry: plane)
        planeNode.simdPosition = float3(planeAnchor.center.x, 0, planeAnchor.center.z)
        planeNode.eulerAngles.x = -.pi / 2
        planeNode.opacity = 0.25
        node.addChildNode(planeNode)
        self.plane = planeNode
    }
    
    // MARK: - Setup Gestures
    
    func addEUMapTapGestureToSceneView() {
        let addEUMapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addMapToSceneView(withGestureRecognizer:)))
        self.gestureSetMapRecognizer = addEUMapGestureRecognizer
        sceneView.addGestureRecognizer(addEUMapGestureRecognizer)
    }
    
//    func addRotateGestureToScenView() {
//        let addEUMapRotateGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(rotateMap(recognizer:)))
//        sceneView.addGestureRecognizer(addEUMapRotateGestureRecognizer)
//    }
    
    func addSelectCountryTapGestureToSceneView() {
        if let gest = gestureSetMapRecognizer{
            sceneView.removeGestureRecognizer(gest)
        }
        let selectCountryGestrueRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectCountry(_:)))
        self.gestureSelectCountryRecognizer = selectCountryGestrueRecognizer
        sceneView.addGestureRecognizer(selectCountryGestrueRecognizer)
    }
    
    func addSelectBarTapGestureToSceneView() {
        if let gest = gestureSelectCountryRecognizer {
            sceneView.removeGestureRecognizer(gest)
        }
        let selectBarGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectBar(_:)))
        self.gestureBarRecognizer = selectBarGestureRecognizer
        sceneView.addGestureRecognizer(selectBarGestureRecognizer)
    }
    // MARK: MainViewDelegate
    func mainView(didPressBtn view: MainView) {
        //        if inStartMode {
        //            inStartMode = false
        //        }
        
        if isShowingData {
            //            print("schowaj bary")
            //            isShowingData = false
            //            gameManager.dataWasPresented()
        }
        if turnEnd {
            turnEnd = false
            gameManager.dataWasPresented()
        }
    }
    
    func choose(date: Int, for nodeType: BarNodeType) {
        selectedDatas[date] = nodeType.value
        if selectedDatas.count == 3 {
            gameManager.answer(selectedDatas.map({ ($0.key, $0.value)}))
        }
    }
    
    func mainView(_ view: MainView, didPut workers: Int) {
        // ADDD CODE
        gameManager.putWorkers(workers)
    }
}

extension MainViewController: ARSCNViewDelegate  {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        //guard !inStartMode else { return }
        guard plane == nil else { return }
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        guard mapNode == nil else { return }
        addPlane(at: planeAnchor, to: node)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        //        guard !inStartMode else { return }
        //        guard plane == nil else { return }
        //        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        //        guard mapNode == nil else { return }
        //        addPlane(at: planeAnchor, to: node)
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
