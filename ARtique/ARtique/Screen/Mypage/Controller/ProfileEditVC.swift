//
//  ProfileEditVC.swift
//  ARtique
//
//  Created by 황윤경 on 2022/04/11.
//

import UIKit

class ProfileEditVC: UIViewController {
    @IBOutlet weak var profileImg: UIButton!
    @IBOutlet weak var nicknameTF: UITextField!
    @IBOutlet weak var explanationTV: UITextView!
    @IBOutlet weak var snsTF: UITextField!
    
    let textViewMaxCnt = 100
    var explanationPlaceholder = "ARTI들에게 자신을 소개해보세요!"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNaviBar()
        configureContentView()
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
