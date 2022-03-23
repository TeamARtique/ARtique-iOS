//
//  UITextView+.swift
//  ARtique
//
//  Created by 황윤경 on 2022/03/23.
//

import UIKit

extension UITextView {
    /// setTextViewToViewer - textView를 드래그 불가 뷰어용으로 설정
    func setTextViewToViewer() {
        isScrollEnabled = false
        isUserInteractionEnabled = false
    }
    
    /// setPadding - ARTique textView 기본 padding값 설정
    func setPadding() {
        self.textContainerInset = UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10)
    }
    
    /// setTextViewPlaceholder - textView의 placeholder을 지정해주는 함수, delegate와 함께 사용
    func setTextViewPlaceholder(_ placeholder: String) {
        if text == "" {
            text = placeholder
            textColor = .lightGray
        } else if text == placeholder {
            text = ""
            textColor = .black
        }
    }
    
    /// setRoundTextView - ARTique 테두리 있는 textView 기본 디자인
    func setRoundTextView() {
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 8
        font = .AppleSDGothicR(size: 13)
    }
}
