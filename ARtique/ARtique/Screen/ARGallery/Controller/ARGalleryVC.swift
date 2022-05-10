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

class ARGalleryVC: BaseVC {
    
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
        getARGalleryInfo(exhibitionID: 2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabbar()
        createSessonConfiguration(gallerySceneView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        gallerySceneView.session.pause()
    }
    
    //MARK: IBAction
    @IBAction func switchOnOffDidTap(_ sender: UISwitch) {
        let galleryModel: String = galleryType.galleryModelIdentifier
        
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
    @objc
    private func imageWasSaved(_ image: UIImage, error: Error?, context: UnsafeMutableRawPointer) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        UIApplication.shared.open(URL(string:"photos-redirect://")!)
    }
    
    /// 갤러리 scene 생성 메서드
    private func setupGallerySceneView(type: GalleyType) {
        let galleryScenePath: String = type.galleryScenePath
        gallerySceneView.delegate = self
        galleryScene = SCNScene(named: galleryScenePath)!
        gallerySceneView.scene = galleryScene
        gallerySceneView.scene.rootNode.position = planeRecognizedPosition!
    }
    
    /// 테마값에 따른 갤러리 테마 적용 메서드
    private func setupGalleryTheme(galleryType: GalleyType, themeType: GalleryThemeType) {
        let modelMaterial = themeType.galleryModelMaterial
        let frameIdentifier1: String = galleryType.frameIdentifier1
        let frameIdentifier2: String = galleryType.frameIdentifier2
        let frameColor: UIColor = themeType.frameColor
        let lightColor: UIColor = themeType.lightColor
        let textColor: UIColor = themeType.textColor
        
        // 갤러리 모델 색 or 이미지 구성
        gallerySceneView.scene.rootNode.childNode(withName: galleryType.galleryModelIdentifier, recursively: true)?.geometry?.material(named: "galleryTheme")?.diffuse.contents = modelMaterial
        
        // 프레임 색 구성
        setupFrameColorByTheme(value: galleryType.rawValue, frameIdentifier: frameIdentifier1, frameColor: frameColor)
        galleryType == .maximum ? setupFrameColorByTheme(value: galleryType.rawValue, frameIdentifier: frameIdentifier2, frameColor: frameColor) : nil
        
        // 조명 색 구성
        setupLightColorByTheme(value: galleryType.rawValue, lightColor: lightColor)
        
        // 타이틀 텍스트 색 구성
        setupTextNodeByTheme(value: galleryType.rawValue, textColor: textColor)
    }
    
    /// 갤러리 모델 내 frame -> 테마값에 따른 색 구성 메서드
    private func setupFrameColorByTheme(value: Int, frameIdentifier: String, frameColor: UIColor) {
        let maxValue = value == 30 ? 15 : value
        for i in 1...maxValue {
            gallerySceneView.scene.rootNode.childNode(withName: frameIdentifier + "\(i)", recursively: true)?.geometry?.material(named: "frameColor")?.diffuse.contents = frameColor
        }
    }
    
    /// 갤러리 모델 내 조명 -> 테마값에 따른 색 구성 메서드
    private func setupLightColorByTheme(value: Int, lightColor: UIColor) {
        gallerySceneView.scene.rootNode.childNode(withName: "spot", recursively: true)?.geometry?.material(named: "spot")?.diffuse.contents = lightColor
    }
    
    /// 갤러리 모델 내 title text -> 테마값에 따른 색, 폰트 구성 메서드
    private func setupTextNodeByTheme(value: Int, textColor: UIColor) {
        let maxValue = value == 30 ? 15 : value
        for i in 1...maxValue {
            // textColor
            gallerySceneView.scene.rootNode.childNode(withName: Identifiers.titleText + "\(i)", recursively: true)?.geometry?.material(named: "textColor")?.diffuse.contents = textColor
            
            // font
            if let textGeometry = gallerySceneView.scene.rootNode.childNode(withName: Identifiers.titleText + "\(i)", recursively: true)?.geometry as? SCNText {
                textGeometry.font = UIFont.AppleSDGothicSB(size: 2.5)
            }
        }
    }
    
    /// 갤러리 모델 내 title text -> string 구성 메서드
    private func setupTitleText(value: Int, artwork: [Artwork]) {
        let maxValue = value == 30 ? 15 : value
        for i in 1...maxValue {
            if let textGeometry = gallerySceneView.scene.rootNode.childNode(withName: Identifiers.titleText + "\(i)", recursively: true)?.geometry as? SCNText {
                textGeometry.string = artwork[i - 1].title
            }
        }
    }
    
    /// 갤러리 모델 내 frame artwork -> content UIImage 구성 메서드
    private func setupArtworkImage(value: Int, frameIdentifier: String, artwork: [Artwork]) {
        // TODO: image URL parsing
//        let maxValue = value == 30 ? 15 : value
//        for i in 1...maxValue {
//            gallerySceneView.scene.rootNode.childNode(withName: frameIdentifier1 + "\(i)", recursively: true)?.geometry?.material(named: "content")?.diffuse.contents = artwork[i].image
//        }
    }
}

//MARK: - AR Functions
extension ARGalleryVC: ARSCNViewDelegate {
    
    /// AR Session Create
    func createSessonConfiguration(_ arView: ARSCNView) {
        let configuration = ARWorldTrackingConfiguration()
        arView.session.run(configuration)
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

// MARK: - Network
extension ARGalleryVC {
    private func getARGalleryInfo(exhibitionID: Int) {
        GalleryAPI.shared.getARGalleryInfo(exhibitionID: exhibitionID, completion: { [weak self] networkResult in
            switch networkResult {
            case .success(let res):
                if let data = res as? ARGalleryDataModel {
                    //✅ 받아온 데이터로 AR Scene 구성
                    self?.setupGallerySceneView(type: GalleyType(rawValue: data.gallery.gallerySize) ?? .medium)
                    self?.setupGalleryTheme(galleryType: GalleyType(rawValue: data.gallery.gallerySize) ?? .medium, themeType: GalleryThemeType(rawValue: data.gallery.galleryTheme) ?? .dark)
                    self?.setupTitleText(value: data.gallery.gallerySize, artwork: data.artworks)
                    // TODO: 아트웤 이미지 구성하기
                }
            case .requestErr(let res):
                if let message = res as? String {
                    print(message)
                    self?.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                }
            default:
                self?.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        })
    }
}
