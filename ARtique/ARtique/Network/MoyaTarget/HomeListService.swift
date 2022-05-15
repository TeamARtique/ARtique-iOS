//
//  HomeListService.swift
//  ARtique
//
//  Created by 황윤경 on 2022/05/15.
//

import Foundation
import Moya

enum HomeListService {
    case getExhibitionList(categoryID: Int)
}

extension HomeListService: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getExhibitionList(let categoryID):
            return "/exhibition/main/\(categoryID)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getExhibitionList:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getExhibitionList:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["accessToken": TokenInfo.shared.accessToken ?? ""]
    }
}
