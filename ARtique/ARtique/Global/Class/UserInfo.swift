//
//  UserInfo.swift
//  ARtique
//
//  Created by hwangJi on 2022/04/27.
//

import Foundation

class UserInfo {
    
    /// 유저 관리를 위한 싱글톤 객체 선언
    static let shared = UserInfo()
    
    var userID: Int?
    var userEmail: String?
    var nickname: String?
    var accessToken: String?
    
    private init() {}
}
