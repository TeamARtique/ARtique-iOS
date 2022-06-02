//
//  SettingVC.swift
//  ARtique
//
//  Created by 황윤경 on 2022/06/03.
//

import UIKit
import Then
import SnapKit

class SettingVC: BaseVC {
    private let settingImage = UIImageView()
        .then {
            $0.image = UIImage(named: "Logout")
        }
    
    private var logoutBtn = UIButton()
        .then {
            $0.setTitle("로그아웃", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .AppleSDGothicB(size: 15)
            $0.layer.cornerRadius = 23
            $0.backgroundColor = .black
        }
    
    private var withdrawalBtn = UIButton()
        .then {
            $0.setTitle("회원 탈퇴", for: .normal)
            $0.setTitleColor(.gray3, for: .normal)
            $0.titleLabel?.font = .AppleSDGothicB(size: 15)
            $0.layer.cornerRadius = 23
            $0.backgroundColor = .gray1
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        configureNaviBar()
        configureContentView()
    }
}

// MARK: - Configure
extension SettingVC {
    private func configureLayout() {
        view.addSubview(settingImage)
        settingImage.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(56)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        view.addSubview(logoutBtn)
        logoutBtn.snp.makeConstraints {
            $0.top.equalTo(settingImage.snp.bottom).offset(111)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(46)
        }
        
        view.addSubview(withdrawalBtn)
        withdrawalBtn.snp.makeConstraints {
            $0.top.equalTo(logoutBtn.snp.bottom).offset(13)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(46)
        }
    }
    
    private func configureNaviBar() {
        navigationItem.title = "회원 설정"
        navigationController?.additionalSafeAreaInsets.top = 8
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "BackBtn"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(popVC))
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func configureContentView() {
        view.backgroundColor = .white
    }
}
