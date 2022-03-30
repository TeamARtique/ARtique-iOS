//
//  UINavigationController+.swift
//  ARtique
//
//  Created by 황윤경 on 2022/03/15.
//

import UIKit

extension UINavigationController {
    
    /// 우상단 검정배경 라운드 버튼 구현 함수
    func setRoundRightBarBtn(navigationItem: UINavigationItem, title: String, target: UIViewController, action: Selector) {
        let buttonWidth = 75
        let buttonHeight = 29
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight))
        
        button.backgroundColor = .black
        button.setTitle(title, for: .normal)
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = .AppleSDGothicB(size: 12)
        button.addTarget(target, action: action, for: .touchUpInside)
        
        let rightBarButtonItem = UIBarButtonItem(customView: button)
        rightBarButtonItem.customView?.layer.cornerRadius = CGFloat(buttonHeight / 2)
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
}

extension UINavigationController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
