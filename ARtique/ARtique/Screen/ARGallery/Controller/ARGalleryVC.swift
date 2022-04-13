//
//  ARGalleryVC.swift
//  ARtique
//
//  Created by 황지은 on 2021/12/11.
//

import UIKit
import ARKit
import SceneKit
import AVFoundation

class ARGalleryVC: UIViewController {
    
    // MARK: Properties
    @IBOutlet var gallerySceneView: ARSCNView!
    @IBOutlet var backgroundRemoveSwitch: UISwitch!
    @IBOutlet var captureBtn: UIButton! {
        didSet {
            captureBtn.isHidden = true
        }
    }
    var galleryScene: SCNScene!
    var defaultGalleryNode: SCNNode!
    var planeRecognizedPosition: SCNVector3?
    var galleryType: GalleyType = .minimum
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGallerySceneView(type: galleryType)
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
        var galleryModel: String = ""
        
        switch galleryType {
        case .minimum:
            galleryModel = Identifiers.minimumGalleryModel
        case .medium:
            galleryModel = Identifiers.mediumGalleryModel
        case .maximum:
            galleryModel = Identifiers.maximumGalleryModel
        }
        
        if !sender.isOn {
            gallerySceneView.scene.rootNode.childNodes.filter({ $0.name == galleryModel }).forEach({ $0.isHidden = true })
            captureBtn.isHidden = false
        }
        else {
            gallerySceneView.scene.rootNode.childNodes.filter({ $0.name == galleryModel }).forEach({ $0.isHidden = false })
            captureBtn.isHidden = true
        }
    }
    
    /// view screenshot func
    @IBAction func captureBtnDidTap(_ sender: UIButton) {
        guard let screenshot = self.view.makeScreenShot() else { return }
        
        UIImageWriteToSavedPhotosAlbum(screenshot, self, #selector(imageWasSaved), nil)
    }
    
    @IBAction func dismissBtnDidTap(_ sender: UIButton) {
        self.presentingViewController?.presentingViewController!.dismiss(animated: true, completion: nil)
    }
}

//MARK: - Custom Methods
extension ARGalleryVC {
    
    /// 이미지가 저장되었을 때 호출되는 func
    @objc func imageWasSaved(_ image: UIImage, error: Error?, context: UnsafeMutableRawPointer) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        print("Image was saved in the photo gallery")
        UIApplication.shared.open(URL(string:"photos-redirect://")!)
    }
}

//MARK: - AR Functions
extension ARGalleryVC: ARSCNViewDelegate {
    
    /// AR Session Create
    func createSessonConfiguration(_ arView: ARSCNView) {
        let configuration = ARWorldTrackingConfiguration()
        arView.session.run(configuration)
    }
    
    /// 갤러리 scene 생성
    func setupGallerySceneView(type: GalleyType) {
        var galleryScenePath: String = ""
        
        switch type {
        case .minimum:
            galleryScenePath = Identifiers.minimumGalleryScenePath
        case .medium:
            galleryScenePath = Identifiers.mediumGalleryScenePath
        case .maximum:
            galleryScenePath = Identifiers.maximumGalleryScenePath
        }
        
        gallerySceneView.delegate = self
        galleryScene = SCNScene(named: galleryScenePath)!
        gallerySceneView.scene = galleryScene
        gallerySceneView.scene.rootNode.position = planeRecognizedPosition!
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
