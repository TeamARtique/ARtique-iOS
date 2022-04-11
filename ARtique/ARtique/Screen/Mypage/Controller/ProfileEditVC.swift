//
//  ProfileEditVC.swift
//  ARtique
//
//  Created by 황윤경 on 2022/04/11.
//

import UIKit
import Photos

class ProfileEditVC: UIViewController {
    @IBOutlet weak var profileImg: UIButton!
    @IBOutlet weak var nicknameTF: UITextField!
    @IBOutlet weak var explanationTV: UITextView!
    @IBOutlet weak var snsTF: UITextField!
    var imagePicker:UIImagePickerController!
    
    let textViewMaxCnt = 100
    var explanationPlaceholder = "ARTI들에게 자신을 소개해보세요!"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNaviBar()
        configureContentView()
    }
    
    @IBAction func setProfileImage(_ sender: Any) {
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            openGallery()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { (status) in }
        default:
            let accessConfirmVC = UIAlertController(title: "권한 필요", message: "갤러리 접근 권한이 없습니다. 설정 화면에서 설정해주세요.", preferredStyle: .alert)
            let goSettings = UIAlertAction(title: "설정으로 이동", style: .default) { (action) in
                if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                }
            }
            let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            accessConfirmVC.addAction(goSettings)
            accessConfirmVC.addAction(cancel)
            self.present(accessConfirmVC, animated: true, completion: nil)
        }
    }
}

// MARK: - Configure
extension ProfileEditVC {
    private func configureNaviBar() {
        navigationItem.title = "프로필 수정"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "BackBtn"),
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(popVC))
        navigationController?.setRoundRightBarBtn(navigationItem: self.navigationItem,
                                                  title: "완료",
                                                  target: self,
                                                  action: #selector(bindRightBarButton))
    }
    
    private func configureContentView() {
        profileImg.layer.cornerRadius = profileImg.frame.height / 2
        profileImg.layer.masksToBounds = true
        nicknameTF.setRoundTextField(with: "ARTI")
        explanationTV.setRoundTextView()
        explanationTV.setTextViewPlaceholder(explanationPlaceholder)
        explanationTV.delegate = self
        snsTF.setRoundTextField(with: "www.instagram.com")
    }
}

// MARK: - Custom Methods
extension ProfileEditVC {
    @objc func popVC() {
        // TODO: - Show alert
        navigationController?.popViewController(animated: true)
    }
    
    @objc func bindRightBarButton() {
        // TODO: - post server
        navigationController?.popViewController(animated: true)
    }
    
    private func openGallery() {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
}

//MARK: UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension ProfileEditVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImg: UIImage? = nil
                
        if let possibleImage = info[.editedImage] as? UIImage {
            selectedImg = possibleImage
        } else if let possibleImage = info[.originalImage] as? UIImage {
            selectedImg = possibleImage
        }
        
        profileImg.setBackgroundImage(selectedImg, for: .normal)
        profileImg.contentMode = .scaleAspectFill
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITextViewDelegate
extension ProfileEditVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView.textColor == .textViewPlaceholder else { return }
        textView.textColor = .label
        textView.text = ""
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.setTextViewPlaceholder(explanationPlaceholder)
        }
        
        if textView.text.count > textViewMaxCnt {
            textView.text.removeLast()
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let str = textView.text else { return true }
        let newLength = str.count + text.count - range.length
        return newLength <= textViewMaxCnt + 1
    }
}
