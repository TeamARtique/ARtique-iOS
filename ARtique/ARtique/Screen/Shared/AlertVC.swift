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
    @IBOutlet weak var keepWatchBtn: UIButton!
    @IBOutlet weak var optionStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureContent()
        underlineInTitleText()
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
            self.removeKeepWatchBtn()
            
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
    
    func configureAlertWithTitle(targetView: UIViewController, alertType: AlertType, title: String, leftBtnAction: Selector?, rightBtnAction: Selector) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.alertImage.image = alertType.alertImage
            self.alertImage.snp.updateConstraints {
                $0.height.equalTo(63)
                $0.width.equalTo(72)
            }
            self.removeKeepWatchBtn()

            self.highlightBtn(button: alertType.highlight == "left" ? self.leftBtn : self.rightBtn)
            
            let combination = NSMutableAttributedString()
            let attributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.AppleSDGothicL(size: 16)]
            let attributedStr = NSMutableAttributedString(string: title, attributes: attributes)
            combination.append(attributedStr)
            combination.append(alertType.message)
            self.message.attributedText = combination
            
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
    
    func configureAlertWithBtn(targetView: UIViewController, alertType: AlertType, leftBtnAction: Selector?, rightBtnAction: Selector, keepWatchBtnAction: Selector) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.alertImage.image = alertType.alertImage
            self.alertImage.snp.updateConstraints {
                $0.height.equalTo(63)
                $0.width.equalTo(72)
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
            self.keepWatchBtn.addTarget(targetView, action: keepWatchBtnAction, for: .touchUpInside)
        }
    }
    
    /// 계속 관람하기 타이틀 텍스트에 밑줄을 긋는 메서드
    private func underlineInTitleText() {
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let underlineAttributedString = NSAttributedString(string: "계속 관람하기", attributes: underlineAttribute)
        keepWatchBtn.titleLabel?.attributedText = underlineAttributedString
    }
    
    /// 계속 관람하기 버튼을 사용하지 않는 Alert에서 해당 버튼을 삭제하고 레이아웃을 업데이트하는 메서드
    private func removeKeepWatchBtn() {
        self.keepWatchBtn.removeFromSuperview()
        self.optionStackView.snp.updateConstraints {
            $0.bottom.equalTo(self.alertBaseView.snp.bottom).inset(15)
        }
    }
}
