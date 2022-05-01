//
//  AlertVC.swift
//  ARtique
//
//  Created by 황윤경 on 2022/05/01.
//

import UIKit

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
        message.textAlignment = .center
        
        leftBtn.layer.cornerRadius = leftBtn.frame.height / 2
        leftBtn.layer.borderColor = UIColor.black.cgColor
        leftBtn.layer.borderWidth = 1
        leftBtn.setTitleColor(.black, for: .normal)
        leftBtn.titleLabel?.font = .AppleSDGothicR(size: 15)
        
        rightBtn.layer.cornerRadius = rightBtn.frame.height / 2
        rightBtn.backgroundColor = .black
        rightBtn.titleLabel?.textColor = .white
        rightBtn.setTitleColor(.white, for: .normal)
        rightBtn.titleLabel?.font = .AppleSDGothicR(size: 15)
    }
}
