//
//  ArtworkExplainCVC.swift
//  ARtique
//
//  Created by 황윤경 on 2022/03/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ArtworkExplainCVC: UICollectionViewCell {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var indexBase: UIView!
    @IBOutlet weak var index: UILabel!
    
    let bag = DisposeBag()
    var cellIndex: Int?
    let exhibitionModel = NewExhibition.shared
    let postContentPlaceholder = "상세 설명을 입력하세요"
    let textViewMaxCnt = 100
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
        setNotification()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

// MARK: - Configure
extension ArtworkExplainCVC {
    private func configureView() {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        image.backgroundColor = .black
        titleTextField.setRoundTextField(with: "제목을 입력하세요")
        contentTextView.setRoundTextView()
        titleTextField.delegate = self
        contentTextView.delegate = self
        indexBase.backgroundColor = .white
        indexBase.layer.cornerRadius = indexBase.frame.height / 2
        indexBase.layer.borderWidth = 1
        indexBase.layer.borderColor = UIColor.black.cgColor
        index.font = .AppleSDGothicSB(size: 15)
    }
    
    func configureCell(index: Int) {
        cellIndex = index
        image.image = exhibitionModel.artworks?[index] ?? UIImage()
        configureText(title: exhibitionModel.artworkTitle?[index] ?? "",
                      description: exhibitionModel.artworkExplain?[index] ?? "")
        contentTextView.setTextViewPlaceholder(postContentPlaceholder)
        self.index.text = "\(index + 1)"
        bindText()
    }
    
    private func configureText(title: String, description: String) {
        titleTextField.textColor
        = title == titleTextField.placeholder
        ? .gray2 : .label
        
        contentTextView.textColor
        = description == postContentPlaceholder
        ? .gray2 : .label
        
        titleTextField.text = title
        contentTextView.text = description
    }
    
    private func bindText() {
        titleTextField.rx.text.orEmpty
            .withUnretained(self)
            .subscribe(onNext: { owner, title in
                owner.exhibitionModel.artworkTitle?[owner.cellIndex ?? 0] = title
            })
            .disposed(by: bag)
        
        contentTextView.rx.text.orEmpty
            .withUnretained(self)
            .subscribe(onNext: { owner, content in
                owner.exhibitionModel.artworkExplain?[owner.cellIndex ?? 0] = content
            })
            .disposed(by: bag)
    }
}

// MARK: - Custom Methods
extension ArtworkExplainCVC {
    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
           let baseVC = self.findViewController() as? AddExhibitionVC {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            UIView.animate(withDuration: 0.3) {
                self.scrollView.snp.remakeConstraints {
                    $0.top.equalTo(baseVC.view.safeAreaLayoutGuide.snp.top).offset(16)
                    $0.bottom.equalTo(baseVC.view.snp.bottom).offset(-keyboardHeight)
                }
                self.layoutIfNeeded()
            }
            scrollView.scrollToBottom(animated: true)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.scrollView.snp.remakeConstraints {
                $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
            }
            self.layoutIfNeeded()
        }
    }
}

// MARK: - UITextViewDelegate
extension ArtworkExplainCVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView.textColor == .gray2 else { return }
        textView.textColor = .label
        textView.text = ""
        NotificationCenter.default.post(name: .changeFirstResponder, object: cellIndex)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.setTextViewPlaceholder(postContentPlaceholder)
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

// MARK: - UITextFieldDelegate
extension ArtworkExplainCVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        NotificationCenter.default.post(name: .changeFirstResponder, object: cellIndex)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        contentTextView.becomeFirstResponder()
        return true
    }
}
