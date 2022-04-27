//
//  LoginAPI.swift
//  ARtique
//
//  Created by hwangJi on 2022/04/27.
//

import Foundation
import Moya

class LoginAPI: BaseAPI {
    static let shared = LoginAPI()
    private var provider = MoyaProvider<LoginService>(plugins: [NetworkLoggerPlugin]())
    
    private override init() {}
}

// MARK: - API
extension LoginAPI {
    
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
}
