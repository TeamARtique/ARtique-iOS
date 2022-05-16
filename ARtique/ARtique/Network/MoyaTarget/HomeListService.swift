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
    case getAllExhibitionList(categoryID: Int, sort: String)
}

extension HomeListService: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getExhibitionList(let categoryID):
            return "/exhibition/main/\(categoryID)"
        case .getAllExhibitionList(categoryID: let categoryID, sort: _):
            return "/exhibition/list/\(categoryID)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getExhibitionList, .getAllExhibitionList:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getExhibitionList:
            return .requestPlain
        case .getAllExhibitionList(categoryID: _, sort: let sort):
            return .requestParameters(parameters: ["sort" : sort], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return ["accessToken": TokenInfo.shared.accessToken ?? ""]
    }
}
