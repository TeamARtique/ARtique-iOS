//
//  TicketAPI.swift
//  ARtique
//
//  Created by hwangJi on 2022/05/18.
//

import Foundation
import Moya

class TicketAPI: BaseAPI {
    static let shared = TicketAPI()
    private var provider = MoyaProvider<TicketService>(plugins: [NetworkLoggerPlugin()])
    
    private override init() {}
}

// MARK: - API
extension TicketAPI {
    
    /// [POST] 티켓북 생성 요청
    func requestCreateTicketbook(exhibitionID: Int, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        provider.request(.createTicketbook(exhibitionID: exhibitionID)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                completion(self.judgeStatus(type: CreateTicketModel.self, by: statusCode, data))
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    /// [GET] 티켓북 목록 조회 요청
    func requestTicketbookList(completion: @escaping (NetworkResult<Any>) -> (Void)) {
        provider.request(.getTicketbook) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                completion(self.judgeStatus(type: [TicketListModel].self, by: statusCode, data))
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
}
