//
//  TokenInfo.swift
//  ARtique
//
//  Created by hwangJi on 2022/04/27.
//

import Foundation

class TokenInfo {
    
    /// 액세스 토큰 관리를 위한 싱글톤 객체 선언
    static let shared = TokenInfo()

    var accessToken: String?
    
    private init() {}
}
