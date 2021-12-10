//
//  AddARVC.swift
//  ARtique
//
//  Created by 황지은 on 2021/11/29.
//

import UIKit
import SceneKit
import ARKit

class AddARVC: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    var planeNode: SCNNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        let plane = SCNPlane(width: 1, height: 1)
        
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named : "coco_phoster")
        
        let node = SCNNode()
        node.geometry = plane
        node.geometry?.materials = [material]
        node.position = SCNVector3(0, 0, -1.125)
        //
        let myLight = SCNNode()
        myLight.light = SCNLight()
        myLight.scale = SCNVector3(1,1,1)
        myLight.light?.intensity = 1000
        myLight.eulerAngles = SCNVector3(-92.873, 0, 0)
        myLight.position = SCNVector3(0, 1.416, -1)
        myLight.light?.type = SCNLight.LightType.directional
        myLight.light?.color = UIColor.white
        
        // add the light to the scene
        
        scene.rootNode.addChildNode(node)
        scene.rootNode.addChildNode(myLight)
        
//        sceneView.autoenablesDefaultLighting = true
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - ARSCNViewDelegate
    
    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }
     */
    
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
