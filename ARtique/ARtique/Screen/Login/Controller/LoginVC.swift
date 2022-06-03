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

class LoginVC: BaseVC {
    
    // MARK: Properties
    private let logoImageView = UIImageView().then {
        $0.image = UIImage(named: "SplashView")
        $0.contentMode = .scaleAspectFill
    }
    
    private let detailLabel = UILabel().then {
        $0.numberOfLines = 0
        // TODO: ARTI -> attributedString으로 바꾸기
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
    
    // MARK: Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        navigator = Navigator(vc: self)
        kakaoLoginBtn.press { [weak self] in
            self?.kakaoLogin()
        }
        tmpLogin()
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
                    self.requestKakaoLogin(refreshToken: oauthToken?.refreshToken ?? "")
                }
            }
        }
    }
    
    /// ARtiqueTBC로 present 화면전환하는 메서드
    private func presentToARtiqueTBC() {
        self.navigator?.instantiateVC(destinationViewControllerType: ARtiqueTBC.self, useStoryboard: false, storyboardName: "", naviType: .present, modalPresentationStyle: .fullScreen) { destination in }
    }
    
    /// SignupVC로 present 화면전환하는 메서드
    private func preesentToSignupVC() {
        guard let signupVC = UIStoryboard(name: Identifiers.signupSB, bundle: nil).instantiateViewController(withIdentifier: SignupVC.className) as? SignupVC else { return }

        signupVC.hidesBottomBarWhenPushed = true
        let navi = UINavigationController(rootViewController: signupVC)
        navi.modalPresentationStyle = .fullScreen
        self.present(navi, animated: true)
    }
}

// MARK: - Network
extension LoginVC {
    private func requestKakaoLogin(refreshToken: String) {
        AuthAPI.shared.kakaoLoginAPI(refreshToken: refreshToken, completion: { networkResult in
            switch networkResult {
            case .success(let res):
                if let data = res as? LoginDataModel {
                    self.setUserInfo(userID: data.user.userID,
                                     userEmail: data.user.email,
                                     nickname: data.user.nickname,
                                     accessToken: data.token.accessToken,
                                     refreshToken: data.token.refreshToken)
                    
                    if data.isSignup {
                        /// 회원가입시 SignupVC로 화면전환
                        self.preesentToSignupVC()
                    } else {
                        /// 로그인시 ARTiqueTBC로 화면전환
                        self.presentToARtiqueTBC()
                    }
                }
            case .requestErr(let res):
                if let message = res as? String {
                    print(message)
                    self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                }
            default:
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        })
    }
}

// 시뮬레이터를 위한 임시 로그인
extension LoginVC {
    private func tmpLogin() {
        appleLoginBtn.press { [weak self] in
            guard let self = self else { return }
            UserDefaults.standard.set("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2NTQxODMzNzYsImV4cCI6MTY1Njc3NTM3NiwiaXNzIjoiYXJ0aXF1ZSJ9.oIVYNLd3nYoD934n661_7K16pD74OVwFdBJiUl8KzRc", forKey: UserDefaults.Keys.refreshToken)
            self.navigator?.instantiateVC(destinationViewControllerType: ARtiqueTBC.self, useStoryboard: false, storyboardName: "", naviType: .present, modalPresentationStyle: .fullScreen) { destination in }
        }
    }
}
