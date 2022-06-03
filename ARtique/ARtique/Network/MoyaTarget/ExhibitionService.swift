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
    case deleteExhibition(exhibitionID: Int)
    case editExhibition(exhibitionID: Int, exhibitionData: EditedExhibitionData)
}

extension ExhibitionService: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getExhibitionData(exhibitionID: let exhibitionID), .deleteExhibition(let exhibitionID),
                .editExhibition(exhibitionID: let exhibitionID, exhibitionData: _):
            return "/exhibition/\(exhibitionID)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getExhibitionData:
            return .get
        case .deleteExhibition:
            return .delete
        case .editExhibition:
            return .put
        }
    }
    
    var task: Task {
        switch self {
        case .getExhibitionData, .deleteExhibition:
            return .requestPlain
        case .editExhibition(exhibitionID: _, exhibitionData: let exhibitionData):
            return .requestParameters(parameters: exhibitionData.editedExhibitionParam, encoding: JSONEncoding.prettyPrinted)
        }
    }
    
    var headers: [String : String]? {
        return ["accessToken": TokenInfo.shared.accessToken ?? ""]
    }
}
