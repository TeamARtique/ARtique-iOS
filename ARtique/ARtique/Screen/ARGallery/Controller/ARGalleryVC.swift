//
//  ARGalleryVC.swift
//  ARtique
//
//  Created by 황지은 on 2021/12/11.
//

import UIKit
import ARKit
import SceneKit

class ARGalleryVC: UIViewController {

    // MARK: Properties
    @IBOutlet var gallerySceneView: ARSCNView!
    var defaultGalleryNode: SCNNode!
    
    // MARK: Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGallerySceneView()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        createSessonConfiguration(gallerySceneView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        gallerySceneView.session.pause()
    }
    
    //MARK: IBAction
    @IBAction func switchOnOffDidTap(_ sender: UISwitch) {
        if !sender.isOn {
            
            gallerySceneView.scene.rootNode.childNodes.filter({ $0.name == Identifiers.defaultGalleryModel }).forEach({ $0.isHidden = true })
        }
        else {
            gallerySceneView.scene.rootNode.childNodes.filter({ $0.name == Identifiers.defaultGalleryModel }).forEach({ $0.isHidden = false })
        }
    }
}
//MARK: - AR Functions
extension ARGalleryVC: ARSCNViewDelegate {
    
    //MARK: Custom Method
    func createSessonConfiguration(_ arView: ARSCNView) {
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        arView.session.run(configuration)
    }
    
    func setupGallerySceneView() {
        gallerySceneView.delegate = self
        
        // Create a new scene
        let galleryScene = SCNScene(named: Identifiers.defaultGalleryScenePath)!
        gallerySceneView.scene = galleryScene
    }
    
    //MARK: AR session
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
