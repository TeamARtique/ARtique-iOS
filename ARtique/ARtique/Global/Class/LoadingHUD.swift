//
//  LoadingHUD.swift
//  ARtique
//
//  Created by hwangJi on 2022/06/03.
//

import UIKit

// MARK: - 로딩중 애니메이션
class LoadingHUD: NSObject {
    private static let sharedInstance = LoadingHUD()
    private var backgroundView: UIView?
    private var popupView: UIView?
    private var popupImageView: UIImageView?
    
    class func show() {
        if let window = UIApplication.shared.keyWindow {
            let backgroundView = UIView()
            let popupImageView = UIImageView()
            
            backgroundView.frame = CGRect(x: 0, y: 0, width: window.frame.maxX, height: window.frame.maxY)
            // 윈도우의 크기에 맞춰 설정
            backgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
            popupImageView.frame = CGRect(x: 0, y: 0, width: 345, height: 344)
            popupImageView.center = window.center
            popupImageView.image = LoadingHUD.getAnimationImage()
            popupImageView.animationDuration = 4.0
            popupImageView.animationRepeatCount = 0
            
            window.addSubview(backgroundView)
            window.addSubview(popupImageView)
            sharedInstance.popupImageView?.removeFromSuperview()
            sharedInstance.popupView?.removeFromSuperview()
            sharedInstance.backgroundView?.removeFromSuperview()
            sharedInstance.backgroundView = backgroundView
            sharedInstance.popupImageView = popupImageView
        }
    }
    
    class func hide() {
        if let popupView = sharedInstance.popupView {
            popupView.removeFromSuperview()
        }
        if let backgroundView = sharedInstance.backgroundView {
            backgroundView.removeFromSuperview()
        }
        if let popupImageView = sharedInstance.popupImageView {
            popupImageView.stopAnimating()
            popupImageView.removeFromSuperview()
        }
    }
    
    private class func getAnimationImage() -> UIImage {
        let animationArray: UIImage = UIImage.gif(asset: "loading")!
        return animationArray
    }
}
