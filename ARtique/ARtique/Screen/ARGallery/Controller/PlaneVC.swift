//
//  PlaneVC.swift
//  ARtique
//
//  Created by 황윤경 on 2021/12/11.
//

import ARKit
import SceneKit
import UIKit

class PlaneVC: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var createExhibitionBtn: UIButton!
    
    let updateQueue = DispatchQueue(label: "com.example.apple-samplecode.arkitexample.serialSceneKitQueue")
    var session: ARSession {
        return sceneView.session
    }
    
    // MARK: UI Elements
    /// Onboarding instructions, 아이폰 움직이세요, 계속 움직이세요, 천천히 움직이세요
    let coachingOverlay = ARCoachingOverlayView()
    /// 바닥 인식 사각형
    var focusSquare = FocusSquare()
    var isExhibitionStart = false
    var exhibitionId: Int?
    
    // MARK: Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.session.delegate = self
        
        // Set up coaching overlay.
        setupCoachingOverlay()
        
        // Set up scene content.
        sceneView.scene.rootNode.addChildNode(focusSquare)
    }
    
    override func viewWillAppear(_ animated: Bool) { super.viewWillAppear(animated)
        resetTracking()
        sceneView.session.delegate = self
        UIApplication.shared.isIdleTimerDisabled = true
        sceneView.showsStatistics = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    // 전시회장 연결 부분
    @IBAction func createExhibition(_ sender: Any) {
        guard let galleryVC = self.storyboard?.instantiateViewController(withIdentifier: Identifiers.arGalleryVC) as? ARGalleryVC else { return }
        
        let query = sceneView.getRaycastQuery() ?? ARRaycastQuery(origin: SIMD3(0, 0, 0), direction: SIMD3(0, 0, 0), allowing: .estimatedPlane, alignment: .horizontal)
        if let result = sceneView.castRay(for: query).first {
            galleryVC.planeRecognizedPosition = SCNVector3(
                x: result.worldTransform.columns.3.x,
                y: result.worldTransform.columns.3.y,
                z: result.worldTransform.columns.3.z
            )
        }
        galleryVC.modalTransitionStyle = .crossDissolve
        galleryVC.modalPresentationStyle = .fullScreen
        galleryVC.exhibitionID = exhibitionId
        present(galleryVC, animated: true, completion: nil)
    }
}

//MARK: - Custom Method
extension PlaneVC {
    
    func resetTracking() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        if #available(iOS 12.0, *) {
            configuration.environmentTexturing = .automatic
        }
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    func updateFocusSquare(isObjectVisible: Bool) {
        if isObjectVisible || coachingOverlay.isActive {
            focusSquare.hide()
        } else {
            focusSquare.unhide()
        }
        
        if let camera = session.currentFrame?.camera, case .normal = camera.trackingState,
           let query = sceneView.getRaycastQuery(),
           let result = sceneView.castRay(for: query).first {
            
            updateQueue.async {
                self.sceneView.scene.rootNode.addChildNode(self.focusSquare)
                self.focusSquare.state = .detecting(raycastResult: result, camera: camera)
            }
            
            if !coachingOverlay.isActive {
                createExhibitionBtn.isHidden = false
            }
            
        } else {
            updateQueue.async {
                self.focusSquare.state = .initializing
                self.sceneView.pointOfView?.addChildNode(self.focusSquare)
            }
            createExhibitionBtn.isHidden = true
        }
    }
}

// MARK: - ARSCNViewDelegate
extension PlaneVC: ARSCNViewDelegate, ARSessionDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            self.updateFocusSquare(isObjectVisible: self.isExhibitionStart)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else { return }
    }
}

// MARK: - ARCoachingOverlayViewDelegate
extension PlaneVC: ARCoachingOverlayViewDelegate {
    func setupCoachingOverlay() {
        // Set up coaching view
        coachingOverlay.session = sceneView.session
        coachingOverlay.delegate = self
        
        coachingOverlay.translatesAutoresizingMaskIntoConstraints = false
        sceneView.addSubview(coachingOverlay)
        
        NSLayoutConstraint.activate([
            coachingOverlay.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            coachingOverlay.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            coachingOverlay.widthAnchor.constraint(equalTo: view.widthAnchor),
            coachingOverlay.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        setActivatesAutomatically()
        setGoal()
    }
    
    /// - Tag: CoachingActivatesAutomatically
    func setActivatesAutomatically() {
        coachingOverlay.activatesAutomatically = true
    }
    
    /// - Tag: CoachingGoal
    func setGoal() {
        coachingOverlay.goal = .horizontalPlane
    }
}

// MARK: - ARCoachingOverlayViewDelegate
extension ARSCNView {
    /**
     Type conversion wrapper for original `unprojectPoint(_:)` method.
     Used in contexts where sticking to SIMD3<Float> type is helpful.
     */
    func unprojectPoint(_ point: SIMD3<Float>) -> SIMD3<Float> {
        return SIMD3<Float>(unprojectPoint(SCNVector3(point)))
    }
    
    // - Tag: CastRayForFocusSquarePosition
    func castRay(for query: ARRaycastQuery) -> [ARRaycastResult] {
        return session.raycast(query)
    }
    
    // - Tag: GetRaycastQuery
    func getRaycastQuery(for alignment: ARRaycastQuery.TargetAlignment = .any) -> ARRaycastQuery? {
        return raycastQuery(from: screenCenter, allowing: .estimatedPlane, alignment: alignment)
    }
    
    var screenCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
}
