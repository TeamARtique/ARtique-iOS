//
//  GalleryService.swift
//  ARtique
//
//  Created by hwangJi on 2022/05/11.
//

import Foundation
import Moya

enum GalleryService {
    case getDetailGallery(exhibitionID: Int)
}

extension GalleryService: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getDetailGallery(let exhibitionID):
            return "/gallery/\(exhibitionID)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getDetailGallery:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getDetailGallery:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["accessToken": TokenInfo.shared.accessToken ?? ""]
    }
}
