//
//  PostExplainView.swift
//  ARtique
//
//  Created by 황윤경 on 2022/03/22.
//

import UIKit
import SnapKit

class PostExplainView: UIView {
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    let spacing:CGFloat = 12
    var currentIndex:CGFloat = 0
    let postContentPlaceholder = "상세 설명을 입력하세요"
    var dummyImages = [UIImage(named: "Theme1")!,
                       UIImage(named: "Theme2")!,
                       UIImage(named: "Theme3")!,
                       UIImage(named: "Theme4")!,
                       UIImage(named: "Theme1")!]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setContentView()
        configureMessage()
        configureScrollView()
        configurePostStack()
        setNotification()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setContentView()
        configureMessage()
        configureScrollView()
        configurePostStack()
        setNotification()
    }
    
    private func setContentView() {
        guard let view = loadXibView(with: Identifiers.postExplainView) else { return }
        view.backgroundColor = .clear
        self.addSubview(view)
        
        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configureMessage() {
        message.textColor = .lightGray
        message.font = .AppleSDGothicR(size: 12)
    }
    
    private func configureScrollView() {
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.decelerationRate = UIScrollView.DecelerationRate.fast
    }
    
    private func configurePostStack() {
        stackView.spacing = 12
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        for image in dummyImages {
            let postWriteScrollView = UIScrollView()
            let contentView = UIView()
            postWriteScrollView.addSubview(contentView)
            contentView.snp.makeConstraints {
                $0.edges.equalToSuperview()
                $0.width.equalToSuperview()
            }
            
            // image
            let imageView = UIImageView(image: image)
            contentView.addSubview(imageView)
            imageView.snp.makeConstraints {
                $0.leading.top.trailing.equalToSuperview()
                $0.height.width.equalTo(UIScreen.main.bounds.width - 52)
            }
            
            // postTitle
            let postTitle = UITextField()
            postTitle.setRoundTextField()
            postTitle.placeholder = "제목을 입력하세요"
            postTitle.addLeftPadding()
            contentView.addSubview(postTitle)
            postTitle.snp.makeConstraints {
                $0.top.equalTo(imageView.snp.bottom).offset(23)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(40)
            }
            
            // postContent
            let postContent = UITextView()
            postContent.setRoundTextView()
            postContent.delegate = self
            postContent.setPadding()
            postContent.setTextViewPlaceholder(postContentPlaceholder)
            contentView.addSubview(postContent)
            postContent.snp.makeConstraints {
                $0.top.equalTo(postTitle.snp.bottom).offset(8)
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalToSuperview()
                $0.height.equalTo(130)
            }
            
            stackView.addArrangedSubview(postWriteScrollView)
        }
    }
    
    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        message.textColor = .clear
        let bottomOffset = CGPoint(x: 0, y: 200)
        stackView.subviews.compactMap({ $0 as? UIScrollView}).forEach {
            $0.setContentOffset(bottomOffset, animated: true)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        message.textColor = .lightGray
        stackView.subviews.compactMap({ $0 as? UIScrollView}).forEach {
            $0.scrollToBottom()
        }
    }
}

// MARK: - UIScrollViewDelegate
extension PostExplainView: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let cellWidthIncludeSpacing = scrollView.frame.width - 53 + spacing
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludeSpacing
        var roundedIndex = round(index)
        
        if scrollView.contentOffset.x > targetContentOffset.pointee.x {
            roundedIndex = floor(index)
        } else if scrollView.contentOffset.x < targetContentOffset.pointee.x {
            roundedIndex = ceil(index)
        } else {
            roundedIndex = round(index)
        }
        
        if currentIndex > roundedIndex {
            currentIndex -= 1
            roundedIndex = currentIndex
        } else if currentIndex < roundedIndex {
            currentIndex += 1
            roundedIndex = currentIndex
        }
        
        offset = CGPoint(x: roundedIndex * cellWidthIncludeSpacing - scrollView.contentInset.left,
                         y: scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
}

// MARK: - UITextViewDelegate
extension PostExplainView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.setTextViewPlaceholder(postContentPlaceholder)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.setTextViewPlaceholder(postContentPlaceholder)
        }
    }
}
