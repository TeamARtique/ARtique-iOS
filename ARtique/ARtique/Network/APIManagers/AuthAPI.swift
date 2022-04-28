//
//  AuthAPI.swift
//  ARtique
//
//  Created by hwangJi on 2022/04/27.
//

import Foundation
import Moya

class AuthAPI: BaseAPI {
    static let shared = AuthAPI()
    private var provider = MoyaProvider<AuthService>(plugins: [NetworkLoggerPlugin()])
    
    private override init() {}
}

// MARK: - API
extension AuthAPI {
    
    /// [POST] 카카오로그인 요청
    func kakaoLoginAPI(refreshToken: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        provider.request(.kakaoLogin(refreshToken: refreshToken)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                completion(self.judgeStatus(type: LoginDataModel.self, by: statusCode, data))
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    /// [POST] 엑세스토큰 갱신 요청
    func renewalTokenAPI(refreshToken: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        provider.request(.renewalToken(refreshToken: refreshToken)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                completion(self.judgeStatus(type: Token.self, by: statusCode, data))
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
}
