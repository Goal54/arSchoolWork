//
//  ViewControllerAR.swift
//  Places
//
//  Created by Benjamin GARDIEN on 18/06/2019.
//  Copyright © 2019 Razeware LLC. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class ViewControllerSecondLocation: UIViewController {
  
    @IBOutlet weak var scene: ARSCNView!
    
  override func viewDidLoad() {
    super.viewDidLoad()
    let configuration = ARWorldTrackingConfiguration();
    configuration.planeDetection = .horizontal
    scene.session.run(configuration)
    
  }
  override func didReceiveMemoryWarning() {
    super.viewDidLoad()
  }
  func randomFloat(min: Float, max: Float) -> Float {
    return (Float(arc4random()) / 0xFFFFFFFF) * (max - min) + min
  }
  @IBAction func addCube(_ sender: UIButton) {
    let cubeNode = SCNNode(geometry: SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0))
    let cc = getCameraCoordinates(scene: scene)
    cubeNode.position = SCNVector3(cc.x, cc.y, cc.z)
    scene.scene.rootNode.addChildNode(cubeNode)
  }
  
  struct myCameraCoordinates {
    var x = Float()
    var y = Float()
    var z = Float()
  }
  
  func getCameraCoordinates(scene: ARSCNView) -> myCameraCoordinates{
    let cameraTransform = scene.session.currentFrame?.camera.transform
    let cameraCoordinates = MDLTransform(matrix: cameraTransform!)
    var cc = myCameraCoordinates()
    cc.z = cameraCoordinates.translation.z
    cc.x = cameraCoordinates.translation.x
    cc.y = cameraCoordinates.translation.y
    return cc;
  }
  
  
    @IBAction func addCandle(_ sender: Any) {
        let cupNode = SCNNode()
        let cc = getCameraCoordinates(scene: scene)
        cupNode.position = SCNVector3(cc.x, cc.y, cc.z)
        guard let virtualObjectScene = SCNScene(named: "candle.scn", inDirectory: "Models.scnassets/candle")
            else{return}
        let wrapperNode = SCNNode()
        for child in virtualObjectScene.rootNode.childNodes{
            child.geometry?.firstMaterial?.lightingModel = .physicallyBased
            wrapperNode.addChildNode(child)
        }
        cupNode.addChildNode(wrapperNode)
        scene.scene.rootNode.addChildNode(cupNode)
    }
}

