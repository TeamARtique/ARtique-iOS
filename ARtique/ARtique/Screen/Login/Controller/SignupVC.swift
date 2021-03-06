//
//  SignupVC.swift
//  ARtique
//
//  Created by hwangJi on 2022/06/01.
//

import UIKit
import Photos
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

class SignupVC: BaseVC {
    
    // MARK: IBOutlet
    @IBOutlet weak var baseSV: UIScrollView! {
        didSet {
            baseSV.isScrollEnabled = false
        }
    }
    @IBOutlet weak var profileImg: UIButton!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var explanationTextView: UITextView!
    @IBOutlet weak var explanationCnt: UILabel!
    @IBOutlet weak var snsTextField: UITextField!
    @IBOutlet weak var essentialGuideLabel: UILabel! {
        didSet {
            essentialGuideLabel.isHidden = true
        }
    }
    
    // MARK: Variables
    var imagePicker: UIImagePickerController!
    var artistData: ArtistProfile?
    let bag = DisposeBag()
    let textViewMaxCnt = 100
    var explanationPlaceholder = "소개"
    var isFirstView: Bool?
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNaviBar()
        configureSV()
        bindUserData()
        bindNotificationCenter()
        hideKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        presentAlertWhenFirstView()
    }
    
    // MARK: IBAction
    @IBAction func nicknameTextFieldDidChanged(_ sender: UITextField) {
        if sender.text?.isEmpty == true {
            makeErrorUIInNicknameTextField()
        } else {
            makeDefaultUIInNicknameTextField()
        }
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
extension SignupVC {
    private func configureNaviBar() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.titleView = UIImageView(image: UIImage(named: "blackLogo"))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "dismissBtn"),
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(dismissVC))
        
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
        nicknameTextField.setRoundTextField(with: "닉네임")
        nicknameTextField.delegate = self
        explanationTextView.setRoundTextView()
        explanationTextView.setTextViewPlaceholder(explanationPlaceholder)
        explanationTextView.delegate = self
        snsTextField.setRoundTextField(with: "웹사이트")
        snsTextField.delegate = self
    }
    
    private func makeErrorUIInNicknameTextField() {
        nicknameTextField.layer.borderColor = UIColor.red.cgColor
        essentialGuideLabel.isHidden = false
    }
    
    private func makeDefaultUIInNicknameTextField() {
        nicknameTextField.layer.borderColor = UIColor.gray4.cgColor
        essentialGuideLabel.isHidden = true
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
extension SignupVC {
    @objc func bindRightBarButton() {
        if nicknameTextField.text?.isEmpty == true {
            makeVibrate()
            nicknameTextField.layer.borderColor = UIColor.red.cgColor
            essentialGuideLabel.isHidden = false
        } else {
            let artist = ArtistModel(nickname: nicknameTextField.text ?? "",
                                     profileImage: profileImg.backgroundImage(for: .normal) ?? UIImage(),
                                     introduction: explanationTextView.textColor == .label ? explanationTextView.text : "",
                                     website: snsTextField.text ?? "")
            requestSignup(artist: artist)
        }
        
        dismissKeyboard()
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
    
    /// ARtiqueTBC로 present 화면전환을 하는 메서드
    @objc
    private func presentArtiqueTBC() {
        dismissAlert()
        
        let tbc = ARtiqueTBC()
        tbc.modalPresentationStyle = .fullScreen
        self.navigationController?.present(tbc, animated: true, completion: nil)
    }
    
    /// SignupVC가 사용자에게 보여지는 첫 뷰가 되어야 할 때 회원가입을 마저 완료해달라는 알럿을 띄우는 메서드
    private func presentAlertWhenFirstView() {
        if isFirstView == true {
            Vibration.warning.vibrate()
            popupAlert(targetView: self,
                       alertType: .signupProgress,
                       image: nil,
                       leftBtnAction: nil,
                       rightBtnAction: #selector(dismissAlert))
        }
    }
}

// MARK: - Network
extension SignupVC {
    private func requestSignup(artist: ArtistModel) {
        LoadingHUD.show()
        MypageAPI.shared.editArtistProfile(artist: artist) { [weak self] networkResult in
            guard let self = self else { return }
            switch networkResult {
            case .success(let data):
                if let data = data as? ArtistProfileModel {
                    UserDefaults.standard.set(data.user.nickname, forKey: UserDefaults.Keys.nickname)
                    UserDefaults.standard.set(true, forKey: UserDefaults.Keys.completeSignup)
                    
                    Vibration.success.vibrate()
                    self.popupAlert(targetView: self,
                                    alertType: .completeSignup,
                                    image: nil,
                                    leftBtnAction: nil,
                                    rightBtnAction: #selector(self.presentArtiqueTBC))
                    LoadingHUD.hide()
                }
            case .requestErr(let res):
                if let message = res as? String {
                    print(message)
                    LoadingHUD.hide()
                    self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                }
            default:
                LoadingHUD.hide()
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        }
    }
}

// MARK: UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension SignupVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
extension SignupVC: UITextViewDelegate {
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

// MARK: - UITextFieldDelegate
extension SignupVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nicknameTextField {
            explanationTextView.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
