//
//  UIButton+.swift
//  ARtique
//
//  Created by 황지은 on 2021/11/29.
//

import UIKit
extension UIButton {
    /// UIButton의 State에 따라 backgroundColor를 변경하는 함수입니다.
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        let minimumSize: CGSize = CGSize(width: 1.0, height: 1.0)
        
        UIGraphicsBeginImageContext(minimumSize)
        
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(origin: .zero, size: minimumSize))
        }
        
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.clipsToBounds = true
        self.setBackgroundImage(colorImage, for: state)
    }
    
    /// selected 상태에 따라 버튼 이미지를 바꿔주는 함수
    func toggleButtonImage(_ isBtnSelected: Bool, _ defaultImage: UIImage, _ selectedImage: UIImage) {
        tintColor = .clear
        if isBtnSelected {
            self.setImage(selectedImage, for: .normal)
        } else {
            self.setImage(defaultImage, for: .normal)
        }
    }
}
