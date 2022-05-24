//
//  MypageAPI.swift
//  ARtique
//
//  Created by 황윤경 on 2022/05/24.
//

import Foundation
import Moya

class MypageAPI: BaseAPI {
    static let shared = MypageAPI()
    private var provider = MoyaProvider<MypageService>(plugins: [NetworkLoggerPlugin()])
    
    private override init() {}
}

extension MypageAPI {
    func editArtistProfile(artist: ArtistModel, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        provider.request(.editProfile(artist: artist)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                completion(self.judgeStatus(type: ArtistProfileModel.self, by: statusCode, data))
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
}
