//
//  ExhibitionDetailAPI.swift
//  ARtique
//
//  Created by 황윤경 on 2022/05/17.
//

import Foundation
import Moya

class ExhibitionDetailAPI: BaseAPI {
    static let shared = ExhibitionDetailAPI()
    private var provider = MoyaProvider<ExhibitionService>(plugins: [NetworkLoggerPlugin()])
    
    private override init() {}
}

extension ExhibitionDetailAPI {
    func getExhibitionData(exhibitionID: Int, completion: @escaping(NetworkResult<Any>) -> (Void)) {
        provider.request(.getExhibitionData(exhibitionID: exhibitionID)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                completion(self.judgeStatus(type: DetailModel.self, by: statusCode, data))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteExhibition(exhibitionID: Int, completion: @escaping(NetworkResult<Any>) -> (Void)) {
        provider.request(.deleteExhibition(exhibitionID: exhibitionID)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                completion(self.judgeStatus(type: Deleted.self, by: statusCode, data))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func editExhibition(exhibitionID: Int, exhibitionData: EditedExhibitionData, completion: @escaping(NetworkResult<Any>) -> (Void)) {
        provider.request(.editExhibition(exhibitionID: exhibitionID, exhibitionData: exhibitionData)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                completion(self.judgeStatus(type: DetailModel.self, by: statusCode, data))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
