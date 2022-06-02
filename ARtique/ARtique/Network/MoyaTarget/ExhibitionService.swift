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
            var multipartData = [MultipartFormData]()
            
            let image = exhibitionData.posterImage.jpegData(compressionQuality: 1) ?? Data()
            let imageData = MultipartFormData(provider: .data(image), name: "file", fileName: "image.png", mimeType: "image/png")
            multipartData.append(imageData)
            
            for (key, values) in exhibitionData.editedExhibitionParam {
                let formData = MultipartFormData(provider: .data("\(values)".data(using: .utf8)!), name: key)
                multipartData.append(formData)
            }
            
            return .uploadMultipart(multipartData)
        }
    }
    
    var headers: [String : String]? {
        return ["accessToken": TokenInfo.shared.accessToken ?? ""]
    }
}
