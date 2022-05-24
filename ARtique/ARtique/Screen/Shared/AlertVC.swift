//
//  AlertVC.swift
//  ARtique
//
//  Created by 황윤경 on 2022/05/01.
//

import UIKit
import SnapKit

class AlertVC: UIViewController {
    @IBOutlet weak var alertBaseView: UIView!
    @IBOutlet weak var alertImage: UIImageView!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureContent()
    }
}

// MARK: - Configure
extension AlertVC {
    private func configureContent() {
        alertBaseView.layer.cornerRadius = 14
        
        message.setLineBreakMode()
        message.font = .AppleSDGothicR(size: 16)
        message.textAlignment = .center
        
        leftBtn.layer.cornerRadius = leftBtn.frame.height / 2
        leftBtn.layer.borderColor = UIColor.black.cgColor
        leftBtn.layer.borderWidth = 1
        leftBtn.setTitleColor(.black, for: .normal)
        leftBtn.titleLabel?.font = .AppleSDGothicR(size: 15)
        
        rightBtn.layer.cornerRadius = rightBtn.frame.height / 2
        rightBtn.layer.borderColor = UIColor.black.cgColor
        rightBtn.layer.borderWidth = 1
        rightBtn.setTitleColor(.black, for: .normal)
        rightBtn.titleLabel?.font = .AppleSDGothicR(size: 15)
    }
    
    private func highlightBtn(button: UIButton) {
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
    }
    
    func configureAlert(targetView: UIViewController, alertType: AlertType, image: UIImage?, leftBtnAction: Selector?, rightBtnAction: Selector) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if image != nil {
                self.alertImage.image = image
                self.alertImage.snp.updateConstraints {
                    $0.top.equalToSuperview().offset(30)
                    $0.leading.equalToSuperview().offset(50)
                    $0.trailing.equalToSuperview().offset(-50)
                    $0.bottom.equalTo(self.message.snp.top).offset(-18)
                    $0.height.equalTo(self.alertImage.snp.width).multipliedBy(4.0/3.0)
                }
            } else {
                self.alertImage.image = alertType.alertImage
                self.alertImage.snp.updateConstraints {
                    $0.height.equalTo(63)
                    $0.width.equalTo(72)
                }
            }
            
            self.highlightBtn(button: alertType.highlight == "left" ? self.leftBtn : self.rightBtn)
            self.message.attributedText = alertType.message
            self.leftBtn.setTitle(alertType.leftBtnLabel, for: .normal)
            self.rightBtn.setTitle(alertType.rightBtnLabel, for: .normal)
            self.rightBtn.addTarget(targetView, action: rightBtnAction, for: .touchUpInside)
            guard let leftBtnAction = leftBtnAction else {
                self.leftBtn.isHidden = true
                return
            }
            self.leftBtn.addTarget(targetView, action: leftBtnAction, for: .touchUpInside)
        }
    }
}
