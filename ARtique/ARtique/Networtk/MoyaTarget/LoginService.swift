//
//  LoginService.swift
//  ARtique
//
//  Created by hwangJi on 2022/04/27.
//

import Foundation
import Moya

enum LoginService {
    case kakaoLogin(refreshToken: String)
}

extension LoginService: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    var path: String {
        switch self {
        case .kakaoLogin:
            return "/auth/kakaoLogin"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .kakaoLogin:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .kakaoLogin(let refreshToken):
            return .requestParameters(parameters: ["refreshToken": refreshToken], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
}
