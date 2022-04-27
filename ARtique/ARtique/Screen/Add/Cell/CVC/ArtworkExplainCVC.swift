//
//  ArtworkExplainCVC.swift
//  ARtique
//
//  Created by 황윤경 on 2022/03/24.
//

import UIKit
import RxSwift
import RxCocoa

class ArtworkExplainCVC: UICollectionViewCell {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    let bag = DisposeBag()
    var cellIndex: Int?
    let exhibitionModel = NewExhibition.shared
    let postContentPlaceholder = "상세 설명을 입력하세요"
    let textViewMaxCnt = 100
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

// MARK: - Configure
extension ArtworkExplainCVC {
    private func configureView() {
        scrollView.showsVerticalScrollIndicator = false
        image.backgroundColor = .black
        titleTextField.setRoundTextField(with: "제목을 입력하세요")
        contentTextView.setRoundTextView()
        contentTextView.delegate = self
    }
    
    func configureCell(index: Int) {
        cellIndex = index
        image.image = exhibitionModel.selectedArtwork?[index] ?? UIImage()
        titleTextField.text = exhibitionModel.artworkTitle?[index] ?? ""
        contentTextView.text = exhibitionModel.artworkExplain?[index] ?? ""
        contentTextView.setTextViewPlaceholder(postContentPlaceholder)
        bindText()
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

// MARK: - UITextViewDelegate
extension ArtworkExplainCVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView.textColor == .gray2 else { return }
        textView.textColor = .label
        textView.text = ""
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
