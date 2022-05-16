//
//  ExhibitionService.swift
//  ARtique
//
//  Created by 황윤경 on 2022/05/17.
//

import Foundation
import Moya

enum ExhibitionService {
    case getExhibitionData(exhibitionID: Int)
}

extension ExhibitionService: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getExhibitionData(exhibitionID: let exhibitionID):
            return "/exhibition/\(exhibitionID)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getExhibitionData:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getExhibitionData:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["accessToken": TokenInfo.shared.accessToken ?? ""]
    }
}
