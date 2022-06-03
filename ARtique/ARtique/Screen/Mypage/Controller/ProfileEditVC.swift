//
//  ProfileEditVC.swift
//  ARtique
//
//  Created by 황윤경 on 2022/04/11.
//

import UIKit
import Photos
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

class ProfileEditVC: BaseVC {
    @IBOutlet weak var baseSV: UIScrollView!
    @IBOutlet weak var profileImg: UIButton!
    @IBOutlet weak var profileImgLabel: UILabel!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var explanationTextView: UITextView!
    @IBOutlet weak var explanationCnt: UILabel!
    @IBOutlet weak var snsTextField: UITextField!
    
    var imagePicker: UIImagePickerController!
    var artistData: ArtistProfile?
    let bag = DisposeBag()
    let textViewMaxCnt = 100
    var explanationPlaceholder = "ARTI를 소개할 수 있는 말을 적어주세요"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNaviBar()
        configureSV()
        bindUserData()
        bindUI()
        bindNotificationCenter()
        hideKeyboard()
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
        navigationItem.rightBarButtonItem = navigationController?.roundFilledBarBtn(title: "완료",
                                                                                    target: self,
                                                                                    action: #selector(bindRightBarButton))
    }

    private func configureSV() {
        baseSV.showsVerticalScrollIndicator = false
        baseSV.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
    }
    
    private func configureContentView() {
        profileImg.layer.cornerRadius = profileImg.frame.height / 2
        profileImg.layer.masksToBounds = true
        profileImg.addTarget(self, action: #selector(setProfileImage), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(setProfileImage))
        profileImgLabel.isUserInteractionEnabled = true
        profileImgLabel.addGestureRecognizer(tapGesture)
        nicknameTextField.setRoundTextField(with: "ARTI")
        nicknameTextField.delegate = self
        explanationTextView.setRoundTextView()
        explanationTextView.setTextViewPlaceholder(explanationPlaceholder)
        explanationTextView.delegate = self
        snsTextField.setRoundTextField(with: "ARTI의 작품을 소개할 수 있는 웹사이트 링크를 등록해주세요")
        snsTextField.delegate = self
    }
    
    private func bindUI() {
        nicknameTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: {[weak self] text in
                guard let self = self else { return }
                self.navigationItem.rightBarButtonItem?.customView?.backgroundColor = text.isEmpty ? .gray1 : .black
                self.navigationItem.rightBarButtonItem?.isEnabled = text.isEmpty ? false : true
            })
            .disposed(by: bag)
        
        explanationTextView.rx.text.orEmpty
            .withUnretained(self)
            .subscribe(onNext: { owner, explain in
                owner.setTextViewMaxCnt(explain.count)
            })
            .disposed(by: bag)
    }
    
    private func bindNotificationCenter() {
        NotificationCenter.default.keyboardWillShowObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, info in
                if owner.explanationTextView.isFirstResponder {
                    owner.baseSV.scrollToOffset(offset: 100, animated: true)
                } else if owner.snsTextField.isFirstResponder {
                    owner.baseSV.scrollToBottom(animated: true)
                }
            })
            .disposed(by: bag)
        
        NotificationCenter.default.keyboardWillHideObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, info in
                owner.baseSV.scrollToTop()
            })
            .disposed(by: bag)
    }
    
    private func bindUserData() {
        let processor = ResizingImageProcessor(referenceSize: CGSize(width: 120, height: 120))
        let modifier = AnyImageModifier { return $0.withRenderingMode(.alwaysOriginal) }
        profileImg.kf.setBackgroundImage(with: URL(string: artistData?.profileImage ?? ""),
                           for: .normal,
                           placeholder: UIImage(named: "DefaultProfile")?
                            .resized(to: CGSize(width: 120, height: 120)),
                           options: [
                            .scaleFactor(UIScreen.main.scale),
                            .processor(processor),
                            .imageModifier(modifier),
                            .cacheOriginalImage
                           ])
        nicknameTextField.text = artistData?.nickname ?? ""
        explanationTextView.text = artistData?.introduction ?? ""
        snsTextField.text = artistData?.website ?? ""
        configureContentView()
    }
}

// MARK: - Custom Methods
extension ProfileEditVC {
    @objc func bindRightBarButton() {
        dismissKeyboard()
        setArtistDataAndEditProfile()
    }
    
    private func openGallery() {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func setTextViewMaxCnt(_ cnt: Int) {
        if explanationTextView.textColor != .gray2 {
            explanationCnt.text = "(\(cnt)/\(textViewMaxCnt))"
        }
    }
    
    @objc func setProfileImage() {
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
    
    private func setArtistDataAndEditProfile() {
        let artist = ArtistModel(nickname: nicknameTextField.text ?? "",
                                 profileImage: profileImg.backgroundImage(for: .normal) ?? UIImage(),
                                 introduction: explanationTextView.textColor == .label ? explanationTextView.text : "",
                                 website: snsTextField.text ?? "")
        editProfile(artist: artist)
    }
}

// MARK: - Network
extension ProfileEditVC {
    private func editProfile(artist: ArtistModel) {
        MypageAPI.shared.editArtistProfile(artist: artist) { [weak self] networkResult in
            guard let self = self else { return }
            switch networkResult {
            case .success(let data):
                if let data = data as? ArtistProfileModel {
                    UserDefaults.standard.set(data.user.nickname, forKey: UserDefaults.Keys.nickname)
                    self.navigationController?.popViewController(animated: true)
                }
            case .requestErr(let res):
                if let message = res as? String {
                    print(message)
                    self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                } else if res is Bool {
                    self.requestRenewalToken() { _ in
                        self.setArtistDataAndEditProfile()
                    }
                }
            default:
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        }
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
        guard textView.textColor == .gray2 else { return }
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
        if text == "\n" {
            snsTextField.becomeFirstResponder()
        }
        
        let newLength = textView.text.count + text.count - range.length
        return newLength <= textViewMaxCnt + 1
    }
}

extension ProfileEditVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nicknameTextField {
            explanationTextView.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
