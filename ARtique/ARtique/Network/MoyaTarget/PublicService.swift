//
//  PublicService.swift
//  ARtique
//
//  Created by hwangJi on 2022/05/24.
//

import Foundation
import Moya

enum PublicService {
    case like(exhibitionID: Int)
    case bookmark(exhibitionID: Int)
}

extension PublicService: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    var path: String {
        switch self {
        case .like(let exhibitionID):
            return "/like/\(exhibitionID)"
        case .bookmark(let exhibitionID):
            return "/bookmark/\(exhibitionID)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .like, .bookmark:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .like, .bookmark:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["accessToken": TokenInfo.shared.accessToken ?? ""]
    }
}
