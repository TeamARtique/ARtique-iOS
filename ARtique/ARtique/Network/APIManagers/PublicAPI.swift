//
//  PublicAPI.swift
//  ARtique
//
//  Created by hwangJi on 2022/05/24.
//

import Foundation
import Moya

class PublicAPI: BaseAPI {
    static let shared = PublicAPI()
    private var provider = MoyaProvider<PublicService>(plugins: [NetworkLoggerPlugin()])
    
    private override init() {}
}

// MARK: - API
extension PublicAPI {
    
    /// [GET] 게시글 좋아요/좋아요 취소 요청
    func requestLikeExhibition(exhibitionID: Int, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        provider.request(.like(exhibitionID: exhibitionID)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                completion(self.judgeStatus(type: Liked.self, by: statusCode, data))
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    /// [GET] 게시글 북마크/북마크 취소 요청
    func requestBookmarkExhibition(exhibitionID: Int, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        provider.request(.bookmark(exhibitionID: exhibitionID)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                completion(self.judgeStatus(type: Bookmarked.self, by: statusCode, data))
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
}
