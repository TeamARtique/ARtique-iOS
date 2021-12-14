//
//  ARGalleryVC.swift
//  ARtique
//
//  Created by 황지은 on 2021/12/11.
//

import UIKit
import ARKit
import SceneKit

class ARGalleryVC: UIViewController, ARSCNViewDelegate {

    // MARK: - Properties
    @IBOutlet var gallerySceneView: ARSCNView!
    
    //nodes
    var defaultGalleryNode: SCNNode!
    var frame1: SCNNode!
    var frame2: SCNNode!
    var frame3: SCNNode!
    var frame4: SCNNode!
    var frame5: SCNNode!
    public let camera = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        setupGallerySceneView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        gallerySceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        gallerySceneView.session.pause()
    }
    
    func setupGallerySceneView() {
        gallerySceneView.delegate = self
//        gallerySceneView.showsStatistics = true
        
        // Create a new scene
        let galleryScene = SCNScene(named: "art.scnassets/DefaultModel/defaultGallery.scn")!
        
        gallerySceneView.scene = galleryScene
//
//        camera.camera = SCNCamera()
//        camera.position = SCNVector3(x: 0, y: -70, z: 50)
//        camera.eulerAngles = SCNVector3(x: 0.74533, y: 0, z: 0)
//
//        frame1 = galleryScene.rootNode.childNode(withName: Identifiers.defaultFrame1, recursively: false)!
//        frame2 = galleryScene.rootNode.childNode(withName: Identifiers.defaultFrame2, recursively: false)!
//        frame3 = galleryScene.rootNode.childNode(withName: Identifiers.defaultFrame3, recursively: false)!
//        frame4 = galleryScene.rootNode.childNode(withName: Identifiers.defaultFrame4, recursively: false)!
//        frame5 = galleryScene.rootNode.childNode(withName: Identifiers.defaultFrame5, recursively: false)!
//
//        let nodes = [frame1, frame2, frame3, frame4, frame5]
//        for i in 0...nodes.count - 1 {
//            let location = nodes[i]!.convertPosition(nodes[i]!.position, to: galleryScene.rootNode)
//            let radius = nodes[i]!.position.y
//            let moveCameraAc = SCNAction.move(to: location, duration: 2)
//            moveCameraAc.timingMode = .easeInEaseOut
//            camera.runAction(moveCameraAc)
//        }
    }
    
    @IBAction func switchOnOffDidTap(_ sender: UISwitch) {
        if !sender.isOn {
            
            gallerySceneView.scene.rootNode.childNodes.filter({ $0.name == Identifiers.defaultGalleryModel }).forEach({ $0.isHidden = true })
        }
        else {
            gallerySceneView.scene.rootNode.childNodes.filter({ $0.name == Identifiers.defaultGalleryModel }).forEach({ $0.isHidden = false })
        }
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
