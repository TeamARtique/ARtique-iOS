//
//  ArtworkExplainCVC.swift
//  ARtique
//
//  Created by 황윤경 on 2022/03/24.
//

import UIKit

class ArtworkExplainCVC: UICollectionViewCell {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    let postContentPlaceholder = "상세 설명을 입력하세요"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }
    
    private func configureView() {
        scrollView.showsVerticalScrollIndicator = false
        
        titleTextField.setRoundTextField()
        titleTextField.addLeftPadding()
        titleTextField.placeholder = "제목을 입력하세요"
        
        contentTextView.setRoundTextView()
        contentTextView.setPadding()
        contentTextView.setTextViewPlaceholder(postContentPlaceholder)
        contentTextView.isScrollEnabled = false
        contentTextView.delegate = self
    }
    
    func configureCell(with artwork: UIImage) {
        image.image = artwork
    }
}

// MARK: - UITextViewDelegate
extension ArtworkExplainCVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.setTextViewPlaceholder(postContentPlaceholder)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.setTextViewPlaceholder(postContentPlaceholder)
        }
    }
}
