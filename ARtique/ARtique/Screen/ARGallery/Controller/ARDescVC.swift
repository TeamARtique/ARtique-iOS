//
//  ARDescVC.swift
//  ARtique
//
//  Created by hwangJi on 2022/06/04.
//

import UIKit
import Then

class ARDescVC: BaseVC {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var betweenView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var seeARBtn: UIButton!
    
    var titleText: String?
    var descText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setOptionalValues()
        setTapGuesture()
    }
    
    func setOptionalValues() {
        if titleText != "" && descText == "" {
            betweenView.isHidden = true
            descLabel.isHidden = true
            titleLabel.text = titleText
        } else if titleText == "" && descText == "" {
            betweenView.isHidden = true
            titleLabel.isHidden = true
            descLabel.text = "등록된 작품 제목과 설명이 없습니다."
        } else if titleText == "" && descText != "" {
            betweenView.isHidden = true
            titleLabel.isHidden = true
            descLabel.text = descText
        } else {
            titleLabel.text = titleText
            descLabel.text = descText
        }
        
        titleLabel.sizeToFit()
        descLabel.sizeToFit()
    }
    
    
    private func configureUI() {
        backView.layer.cornerRadius = 15
        backView.clipsToBounds = true
        backView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        seeARBtn.layer.cornerRadius = seeARBtn.frame.height / 2
        seeARBtn.clipsToBounds = true
    }
    
    private func setTapGuesture() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissVC))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func seeARBtnDidTap(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
