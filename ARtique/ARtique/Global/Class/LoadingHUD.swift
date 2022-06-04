//
//  LoadingHUD.swift
//  ARtique
//
//  Created by hwangJi on 2022/06/03.
//

import UIKit
import Gifu
import Then

// MARK: - 로딩중 애니메이션
class LoadingHUD: NSObject {
    private static let sharedInstance = LoadingHUD()
    private var backgroundView: UIView?
    private var popupView: UIView?
    private var popupImageView: GIFImageView?
    
    class func show() {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        
        if let window = windowScene?.windows.first(where: { $0.isKeyWindow }) {
            
            let backgroundView = UIView()
            let popupImageView = GIFImageView()
            
            backgroundView.frame = CGRect(x: 0, y: 0, width: window.frame.maxX, height: window.frame.maxY)
            // 윈도우의 크기에 맞춰 설정
            backgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
            popupImageView.frame = CGRect(x: 0, y: 0, width: 345, height: 344)
            popupImageView.center = window.center
            popupImageView.animate(withGIFNamed: "loading")
            
            sharedInstance.popupImageView?.removeFromSuperview()
            sharedInstance.popupView?.removeFromSuperview()
            sharedInstance.backgroundView?.removeFromSuperview()
            sharedInstance.backgroundView = backgroundView
            sharedInstance.popupImageView = popupImageView
            window.addSubview(backgroundView)
            window.addSubview(popupImageView)
            
        }
    }
    
    class func hide() {
        DispatchQueue.main.async {
            if let popupView = sharedInstance.popupView {
                popupView.removeFromSuperview()
            }
            if let backgroundView = sharedInstance.backgroundView {
                backgroundView.removeFromSuperview()
            }
            if let popupImageView = sharedInstance.popupImageView {
                popupImageView.stopAnimatingGIF()
                popupImageView.removeFromSuperview()
            }
        }
    }
}

