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
        bindNotificationCenter()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleTextField.text = ""
        contentTextView.text = ""
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
        image.image = exhibitionModel.artworks?[index].image ?? UIImage()
        configureText(title: exhibitionModel.artworks?[index].title ?? "",
                      description: exhibitionModel.artworks?[index].description ?? "")
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
                owner.exhibitionModel.artworks?[owner.cellIndex ?? 0].title = title
            })
            .disposed(by: bag)
        
        contentTextView.rx.text.orEmpty
            .withUnretained(self)
            .subscribe(onNext: { owner, description in
                owner.exhibitionModel.artworks?[owner.cellIndex ?? 0].description
                = description == owner.postContentPlaceholder
                ? "" : description
            })
            .disposed(by: bag)
    }
}

// MARK: - Custom Methods
extension ArtworkExplainCVC {
    private func bindNotificationCenter() {
        NotificationCenter.default.keyboardWillChangeFrame()
            .withUnretained(self)
            .subscribe(onNext: { owner, info in
                if let baseVC = self.findViewController() as? AddExhibitionVC {
                    UIView.animate(withDuration: info.duration) {
                        self.scrollView.snp.remakeConstraints {
                            $0.top.equalTo(baseVC.view.safeAreaLayoutGuide.snp.top).offset(16)
                            $0.bottom.equalTo(baseVC.view.snp.bottom).offset(-info.height)
                        }
                        self.layoutIfNeeded()
                    }
                    self.scrollView.scrollToBottom(animated: true)
                }
            })
            .disposed(by: bag)
        
        NotificationCenter.default.keyboardWillHideObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, info in
                UIView.animate(withDuration: info.duration) {
                    self.scrollView.snp.remakeConstraints {
                        $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
                    }
                    self.layoutIfNeeded()
                }
            })
            .disposed(by: bag)
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
        if text == "\n" {
            textView.resignFirstResponder()
        }
        
        let newLength = textView.text.count + text.count - range.length
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
