//
//  UIView+.swift
//  ARtique
//
//  Created by 황지은 on 2021/11/29.
//

import UIKit
import SnapKit

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
    
    func makeScreenShot() -> UIImage? {
        let scale = UIScreen.main.scale
        let bounds = self.bounds
        
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, scale)
        
        if let _ = UIGraphicsGetCurrentContext() {
            self.drawHierarchy(in: bounds, afterScreenUpdates: true)
            
            let screenshot = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return screenshot
        }
        return nil
    }
    
    /// xib 파일을 불러오는 함수
    func loadXibView(with xibName: String) -> UIView? {
        return Bundle.main.loadNibNamed(xibName, owner: self, options: nil)?.first as? UIView
    }
    
    /**
     - Description:
     VC나 View 내에서 해당 함수를 호출하면, 햅틱이 발생하는 메서드입니다.
     버튼을 누르거나 유저에게 특정 행동이 발생했다는 것을 알려주기 위해 다음과 같은 햅틱을 활용합니다.
     
     - parameters:
     - degree: 터치의 세기 정도를 정의. 보통은 medium,light를 제일 많이 활용합니다.
     */
    func makeVibrate(degree : UIImpactFeedbackGenerator.FeedbackStyle = .medium)
    {
        let generator = UIImpactFeedbackGenerator(style: degree)
        generator.impactOccurred()
    }
    
    /// view를 담당하는 viewController를 찾는 함수
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
    
    /// view를 이미지로 전환해주는 함수
    func transfromToImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0.0)
        defer {
            UIGraphicsEndImageContext()
        }
        if let context = UIGraphicsGetCurrentContext() {
            layer.render(in: context)
            return UIGraphicsGetImageFromCurrentImageContext()
        }
        return nil
    }
    
    /// degrees 만큼 view를 회전시켜주는 함수
    func rotate(degrees: CGFloat) {
        self.transform = CGAffineTransform(rotationAngle: CGFloat.pi * degrees / 180.0)
    }
}
