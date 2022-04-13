//
//  LoginVC.swift
//  ARtique
//
//  Created by hwangJi on 2022/04/05.
//

import UIKit
import SnapKit
import Then
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

class LoginVC: UIViewController {
    
    // MARK: Properties
    private let logoImageView = UIImageView().then {
        $0.image = UIImage(named: "SplashView")
        $0.contentMode = .scaleAspectFill
    }
    
    // TODO: ARTI -> attributedString으로 바꾸기
    private let detailLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.text = "소셜 로그인으로 간편하게 ARTI가 되어\n언제 어디서나 다양한 전시를 즐기고\n나만의 전시를 만들어 보세요."
        $0.font = .AppleSDGothicL(size: 14.0)
        $0.textAlignment = .center
    }
    
    private let kakaoLoginBtn = UIButton().then {
        $0.setBackgroundImage(UIImage(named: "kakaoLogin"), for: .normal)
        $0.contentMode = .scaleAspectFit
    }
    
    private let appleLoginBtn = UIButton().then {
        $0.setBackgroundImage(UIImage(named: "appleLogin"), for: .normal)
        $0.contentMode = .scaleAspectFit
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        kakaoLoginBtn.press {
            self.kakaoLogin()
        }
    }
}

// MARK: - UI
extension LoginVC {
    private func configureUI() {
        self.view.addSubviews([logoImageView, detailLabel, kakaoLoginBtn, appleLoginBtn])
        self.view.backgroundColor = .white
        
        logoImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(186)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(calculateHeightbyScreenHeight(originalHeight: 118))
            $0.width.equalTo(calculateHeightbyScreenHeight(originalHeight: 118) * 136 / 118)
        }
        
        detailLabel.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(34)
            $0.centerX.equalToSuperview()
        }
        
        kakaoLoginBtn.snp.makeConstraints {
            $0.top.equalTo(detailLabel.snp.bottom).offset(130)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(calculateHeightbyScreenHeight(originalHeight: 47))
            $0.width.equalTo(calculateHeightbyScreenHeight(originalHeight: 47) * 335 / 47)
        }
        
        appleLoginBtn.snp.makeConstraints {
            $0.top.equalTo(kakaoLoginBtn.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(kakaoLoginBtn)
        }
    }
}

// MARK: - Custom Methods
extension LoginVC {
    private func kakaoLogin() {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    print("loginWithKakaoTalk() success.")
                    // TODO: accessToken post 서버 연결
                    print(oauthToken?.accessToken)
                }
            }
        }
    }
}

