//
//  GalleryAPI.swift
//  ARtique
//
//  Created by hwangJi on 2022/05/11.
//

import Foundation
import Moya

class GalleryAPI: BaseAPI {
    static let shared = GalleryAPI()
    private var provider = MoyaProvider<GalleryService>(plugins: [NetworkLoggerPlugin()])
    
    private override init() {}
}

// MARK: - API
extension GalleryAPI {
    
    /// [GET] AR 전시관 상세조회 요청
    func getARGalleryInfo(exhibitionID: Int, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        provider.request(.getDetailGallery(exhibitionID: exhibitionID)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                completion(self.judgeStatus(type: ARGalleryDataModel.self, by: statusCode, data))
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
}
