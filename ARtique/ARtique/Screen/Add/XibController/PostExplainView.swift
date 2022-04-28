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
    @IBOutlet weak var artworkListView: ArtworkListView!
    @IBOutlet weak var artworkListViewTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var artworkListViewBottomAnchor: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setContentView()
        configureMessage()
        configureArtworkView()
        setNotification()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setContentView()
        configureMessage()
        configureArtworkView()
        setNotification()
    }
}

// MARK: - Configure
extension PostExplainView {
    private func setContentView() {
        guard let view = loadXibView(with: Identifiers.postExplainView) else { return }
        view.backgroundColor = .clear
        self.addSubview(view)
        
        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configureMessage() {
        message.textColor = .gray3
        message.font = .AppleSDGothicR(size: 12)
    }
    
    private func configureArtworkView() {
        artworkListView.isOrderView = false
    }
}

// MARK: - Custom Methods
extension PostExplainView {
    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let animateDuration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        let heiget = keyboardFrame.size.height - safeAreaInsets.bottom
        
        message.textColor = .clear
        UIView.animate(withDuration: animateDuration) {
            self.artworkListViewTopAnchor.constant = 0
            self.artworkListViewBottomAnchor.constant = 55 + 79
            self.artworkListView.artworkCV.subviews
                .compactMap({ $0 as? ArtworkExplainCVC })
                .forEach {
                    $0.scrollView.contentInset.top = 20
                    $0.scrollView.contentInset.bottom = heiget - 100
                    $0.scrollView.scrollToBottom()
                }
            self.artworkListView.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        message.textColor = .gray3
        artworkListViewTopAnchor.constant = 79
        artworkListViewBottomAnchor.constant = 55
        artworkListView.artworkCV.subviews
            .compactMap({ $0 as? ArtworkExplainCVC })
            .forEach {
                $0.scrollView.contentInset.top = 0
                $0.scrollView.contentInset.bottom = 0
                $0.scrollView.scrollToBottom()
        }
        artworkListView.layoutIfNeeded()
    }
}
