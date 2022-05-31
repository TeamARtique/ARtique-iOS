//
//  ProfileImageVC.swift
//  ARtique
//
//  Created by 황윤경 on 2022/05/30.
//

import UIKit
import SnapKit
import Then

class ProfileImageVC: BaseVC {
    var profileImage = UIImageView()
    private var dismissBtn = UIButton()
        .then {
            $0.setImage(UIImage(named: "dismiss_white"), for: .normal)
            $0.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        }
    var initialTouchPoint = CGPoint.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureContentView()
        configureLayout()
        setDismissGesture()
    }
    
    private func configureContentView() {
        view.backgroundColor = .black
    }
    
    private func configureLayout() {
        view.addSubview(dismissBtn)
        view.addSubview(profileImage)
        
        dismissBtn.snp.makeConstraints {
            $0.top.equalTo(view.snp.top).offset(safeAreaTopInset() + 25)
            $0.leading.equalToSuperview().offset(15)
            $0.width.height.equalTo(30)
        }
        
        profileImage.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.equalTo(profileImage.snp.width)
        }
    }
    
    private func setDismissGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureDismiss(_:)))
        self.view.addGestureRecognizer(panGesture)
    }
    
    @objc func panGestureDismiss(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: view?.window)
        
        switch sender.state {
        case .began:
            initialTouchPoint = touchPoint
        case .changed:
            if touchPoint.y > initialTouchPoint.y {
                view.frame.origin.y = touchPoint.y - initialTouchPoint.y
            }
        case .ended, .cancelled:
            if touchPoint.y - initialTouchPoint.y > 200 {
                dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.frame = CGRect(x: 0,
                                             y: 0,
                                             width: self.view.frame.size.width,
                                             height: self.view.frame.size.height)
                })
            }
        default:
            break
        }
    }
}
