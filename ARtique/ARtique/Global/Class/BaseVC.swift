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
    
    /// 로그인/자동로그인 시 유저의 정보를 저장하는 메서드
    func setUserInfo(userID: Int, userEmail: String, nickname: String, accessToken: String, refreshToken: String) {
        UserInfo.shared.userID = userID
        UserInfo.shared.userEmail = userEmail
        UserInfo.shared.nickname = nickname
        UserInfo.shared.accessToken = accessToken
        UserDefaults.standard.set(refreshToken, forKey: UserDefaults.Keys.refreshToken)
    }
}

// MARK: - Network
extension BaseVC {
    /// 액세스 토큰 갱신 API 등 다른 VC에서도 호출되는 네트워크 코드를 여기다가 만들어줍시다!
}

