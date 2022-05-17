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
import Kingfisher

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
        getARGalleryInfo(exhibitionID: 107)
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
    private func setupGalleryTheme(maxValue: Int, frameIdentifier1: String, frameIdentifier2: String, galleryType: GalleyType, themeType: ThemeType) {
        let modelMaterial = themeType.galleryModelMaterial
        let frameColor: UIColor = themeType.frameColor
        let lightColor: UIColor = themeType.lightColor
        let textColor: UIColor = themeType.textColor
        
        // 갤러리 모델 색 or 이미지 구성
        gallerySceneView.scene.rootNode.childNode(withName: galleryType.galleryModelIdentifier, recursively: true)?.geometry?.material(named: "galleryTheme")?.diffuse.contents = modelMaterial
        
        // 프레임 색 구성
        setupFrameColorByTheme(maxValue: galleryType.rawValue, frameIdentifier: frameIdentifier1, frameColor: frameColor)
        galleryType == .maximum ? setupFrameColorByTheme(maxValue: galleryType.rawValue, frameIdentifier: frameIdentifier2, frameColor: frameColor) : nil
        
        // 조명 색 구성
        setupLightColorByTheme(maxValue: galleryType.rawValue, lightColor: lightColor)
        
        // 타이틀 텍스트 색 구성
        setupTextNodeByTheme(maxValue: maxValue, textColor: textColor)
    }
    
    /// 갤러리 모델 내 frame -> 테마값에 따른 색 구성 메서드
    private func setupFrameColorByTheme(maxValue: Int, frameIdentifier: String, frameColor: UIColor) {
        for i in 1...maxValue {
            gallerySceneView.scene.rootNode.childNode(withName: frameIdentifier + "\(i)", recursively: true)?.geometry?.material(named: "frameColor")?.diffuse.contents = frameColor
        }
    }
    
    /// 갤러리 모델 내 조명 -> 테마값에 따른 색 구성 메서드
    private func setupLightColorByTheme(maxValue: Int, lightColor: UIColor) {
        for i in 1...maxValue {
            gallerySceneView.scene.rootNode.childNode(withName: "spot\(i)", recursively: true)?.geometry?.material(named: "spot")?.diffuse.contents = lightColor
        }
    }
    
    /// 갤러리 모델 내 title text -> 테마값에 따른 색, 폰트 구성 메서드
    private func setupTextNodeByTheme(maxValue: Int, textColor: UIColor) {
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
    private func setupTitleText(maxValue: Int, artwork: [Artwork]) {
        for i in 1...maxValue {
            if let textGeometry = gallerySceneView.scene.rootNode.childNode(withName: Identifiers.titleText + "\(i)", recursively: true)?.geometry as? SCNText {
                textGeometry.string = artwork[i - 1].title
            }
        }
    }
    
    /// 현재 보여지는 범위의 조명을 켜고 끄는 메서드
    private func turnLightsOnOff(galleryType: GalleyType, value: Int) {
        let frameIdentifier1: String = galleryType.frameIdentifier1
        let maxValue = value == 30 ? 15 : value
        
        for i in 1...maxValue {
            if let pointOfView = gallerySceneView.pointOfView {
                let isMaybeVisible = gallerySceneView.isNode(gallerySceneView.scene.rootNode.childNode(withName: frameIdentifier1 + "\(i)", recursively: true) ?? SCNNode(), insideFrustumOf: pointOfView)
                gallerySceneView.scene.rootNode.childNode(withName: "spot\(i)", recursively: true)?.isHidden = isMaybeVisible ? false : true
            }
        }
    }
    
    /// 갤러리 모델 내 frame artwork -> content UIImage 구성 메서드
    private func setupArtworkImage(frameIdentifier: String, artworkImage: UIImage, index: Int) {
        gallerySceneView.scene.rootNode.childNode(withName: frameIdentifier + "\(index)", recursively: true)?.geometry?.material(named: "content")?.diffuse.contents = artworkImage
    }
    
    /// image URL을 UIImage로 다운로드하여 artwork에 이미지를 구성하는 메서드
    private func downloadImage(with urlString: String, frameIdentifier: String, index: Int) {
        guard let url = URL(string: urlString) else { return }
        let resource = ImageResource(downloadURL: url)
        
        DispatchQueue.global().async {
            KingfisherManager.shared.retrieveImage(with: resource,
                                                   options: nil,
                                                   progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    self.setupArtworkImage(frameIdentifier: frameIdentifier, artworkImage: value.image, index: index)
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
    }
    
    /// 네트워크 통신으로 받아온 실제 URL을 UIImage로 다운로드할 수 있도록 downloadImage 메서드를 호출하는 메서드
    private func downloadImageByRealData(maxValue: Int, artwork: [Artwork], frameIdentifier1: String, frameIdentifier2: String) {
        for i in 0...maxValue - 1 {
            if maxValue == 30 {
                if i % 2 == 0 {
                    downloadImage(with: artwork[i].image, frameIdentifier: frameIdentifier1, index: i / 2 + 1)
                } else {
                    downloadImage(with: artwork[i].image, frameIdentifier: frameIdentifier2, index: (i + 1) / 2)
                }
            } else {
                downloadImage(with: artwork[i].image, frameIdentifier: frameIdentifier1, index: i + 1)
            }
        }
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
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        turnLightsOnOff(galleryType: galleryType, value: galleryType.rawValue)
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
                    self?.galleryType = GalleyType(rawValue: data.gallery.gallerySize) ?? .medium
                    let maxValue = data.gallery.gallerySize
                    let frameIdentifier1: String = self?.galleryType.frameIdentifier1 ?? ""
                    let frameIdentifier2: String = self?.galleryType.frameIdentifier2 ?? ""
                    
                    self?.setupGallerySceneView(type: GalleyType(rawValue: data.gallery.gallerySize) ?? .medium)
                    self?.setupGalleryTheme(maxValue: maxValue, frameIdentifier1: frameIdentifier1, frameIdentifier2: frameIdentifier2, galleryType: GalleyType(rawValue: data.gallery.gallerySize) ?? .medium, themeType: ThemeType(rawValue: data.gallery.galleryTheme) ?? .dark)
                    self?.setupTitleText(maxValue: maxValue, artwork: data.artworks)
                    self?.downloadImageByRealData(maxValue: maxValue, artwork: data.artworks, frameIdentifier1: frameIdentifier1, frameIdentifier2: frameIdentifier2)
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
