//
//  HomeAPI.swift
//  ARtique
//
//  Created by 황윤경 on 2022/05/15.
//

import Foundation
import Moya

class HomeAPI: BaseAPI {
    static let shared = HomeAPI()
    private var provider = MoyaProvider<HomeListService>(plugins: [NetworkLoggerPlugin()])
    
    private override init() {}
}

extension HomeAPI {
    func getHomeExhibitionList(categoryID: Int, completion: @escaping(NetworkResult<Any>) -> (Void)) {
        provider.request(.getExhibitionList(categoryID: categoryID)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                completion(self.judgeStatus(type: HomeModel.self, by: statusCode, data))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getAllExhibitionList(categoryID: Int, sort: String, completion: @escaping(NetworkResult<Any>) -> (Void)) {
        provider.request(.getAllExhibitionList(categoryID: categoryID, sort: sort)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                completion(self.judgeStatus(type: [ExhibitionModel].self, by: statusCode, data))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
