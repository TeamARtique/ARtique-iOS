//
//  RegisterService.swift
//  ARtique
//
//  Created by 황윤경 on 2022/05/17.
//

import Foundation
import Moya

enum RegisterService {
    case registerExhibitionData(exhibitionData: NewExhibition)
}

extension RegisterService: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    var path: String {
        switch self {
        case .registerExhibitionData:
            return "/exhibition/new"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .registerExhibitionData:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .registerExhibitionData(let exhibitionData):
            let body: [String: Any] = [
                "gallerySize": exhibitionData.gallerySize ?? 0,
                "galleryTheme": exhibitionData.galleryTheme ?? 0,
                "title": exhibitionData.title ?? "",
                "category": exhibitionData.category ?? 0,
                "posterImage": exhibitionData.posterURL ?? "",
                "posterOriginalImage": exhibitionData.posterOriginalURL ?? "",
                "posterTheme": exhibitionData.posterTheme ?? 0,
                "description": exhibitionData.description ?? "",
                "tag": exhibitionData.tag ?? [],
                "isPublic": exhibitionData.isPublic ?? false,
                "artworkImage": exhibitionData.artworkImages,
                "artworkTitle": exhibitionData.artworkTitles,
                "artworkDescription": exhibitionData.artworkDescriptions
            ]
            return .requestParameters(parameters: body, encoding: JSONEncoding.prettyPrinted)
        }
    }
    
    var headers: [String : String]? {
        return ["accessToken": TokenInfo.shared.accessToken ?? ""]
    }
}
