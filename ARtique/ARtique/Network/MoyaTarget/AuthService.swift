//
//  AuthService.swift
//  ARtique
//
//  Created by hwangJi on 2022/04/27.
//

import Foundation
import Moya

enum AuthService {
    case kakaoLogin(refreshToken: String)
    case renewalToken(refreshToken: String)
}

extension AuthService: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    var path: String {
        switch self {
        case .kakaoLogin:
            return "/auth/kakaoLogin"
        case .renewalToken:
            return "/auth/token"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .kakaoLogin, .renewalToken:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .kakaoLogin(let refreshToken), .renewalToken(let refreshToken):
            return .requestParameters(parameters: ["refreshToken": refreshToken], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
}
