//
//  UITextField+.swift
//  ARtique
//
//  Created by 황지은 on 2021/11/29.
//

import UIKit
extension UITextField {
    /// addLeftPadding - TextField에서 왼쪽 여백을 width 너비만큼 주는 함수입니다.
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
}
