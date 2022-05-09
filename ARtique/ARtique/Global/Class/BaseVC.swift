//
//  BaseVC.swift
//  ARtique
//
//  Created by hwangJi on 2022/04/27.
//

import UIKit

class BaseVC: UIViewController {
    
    // MARK: Properties
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    var navigator: Navigator?
    
    // MARK: Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - Custom Methods
extension BaseVC {
    func hideTabbar() {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func showTabbar() {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    /// 로그인 시 유저의 정보를 저장하는 메서드
    func setUserInfo(userID: Int, userEmail: String, nickname: String, accessToken: String, refreshToken: String) {
        TokenInfo.shared.accessToken = accessToken
        UserDefaults.standard.set(userID, forKey: UserDefaults.Keys.userID)
        UserDefaults.standard.set(userEmail, forKey: UserDefaults.Keys.userEmail)
        UserDefaults.standard.set(nickname, forKey: UserDefaults.Keys.nickname)
        UserDefaults.standard.set(refreshToken, forKey: UserDefaults.Keys.refreshToken)
    }
    
    @objc func popVC() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Network
extension BaseVC {
    // TODO: 액세스 토큰 갱신 API 등 다른 VC에서도 호출되는 네트워크 코드를 여기다가 만들어줍니다.
    
    /// 엑세스 토큰 갱신, 자동로그인 요청 메서드
    func requestRenewalToken(refreshToken: String) {
        AuthAPI.shared.renewalTokenAPI(refreshToken: refreshToken, completion: { networkResult in
            switch networkResult {
            case .success(let res):
                if let data = res as? Token {
                    TokenInfo.shared.accessToken = data.accessToken
                }
            case .requestErr(let res):
                if let message = res as? String {
                    print(message)
                    self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                    self.requestRenewalToken(refreshToken: UserDefaults.standard.string(forKey: UserDefaults.Keys.refreshToken) ?? "")
                }
            default:
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        })
    }
}

