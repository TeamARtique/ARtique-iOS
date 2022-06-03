//
//  RegisterAPI.swift
//  ARtique
//
//  Created by 황윤경 on 2022/05/17.
//

import Foundation
import Moya

class RegisterAPI: BaseAPI {
    static let shared = RegisterAPI()
    private var provider = MoyaProvider<RegisterService>(plugins: [NetworkLoggerPlugin()])
    
    private override init() {}
}

extension RegisterAPI {
    func postRegisterExhibition(exhibitionData: NewExhibition, completion: @escaping(NetworkResult<Any>) -> (Void)) {
        provider.request(.registerExhibitionData(exhibitionData: exhibitionData)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                completion(self.judgeStatus(type: RegisterModel.self, by: statusCode, data))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
