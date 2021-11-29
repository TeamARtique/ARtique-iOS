//
//  UIView+.swift
//  ARtique
//
//  Created by 황지은 on 2021/11/29.
//

import UIKit
extension UIView {
    //UIView에 다수의 Subviews 한번에 추가
    func addSubviews(_ views: [UIView]) {
        views.forEach { self.addSubview($0) }
    }
    
    //UIView에 Corner
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
