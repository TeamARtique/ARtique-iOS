//
//  RegisterService.swift
//  ARtique
//
//  Created by 황윤경 on 2022/05/17.
//

import Foundation
import Moya

enum RegisterService {
    case postExhibitionData(exhibitionData: NewExhibition)
    case postArtworkData(exhibitionID: Int, artwork: ArtworkData)
    case getRegisterStatus(exhibitionID: Int)
}

extension RegisterService: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    var path: String {
        switch self {
        case .postExhibitionData:
            return "/exhibition"
        case .postArtworkData(exhibitionID: let exhibitionID, artwork: _):
            return "/exhibition/artwork/\(exhibitionID)"
        case .getRegisterStatus(exhibitionID: let exhibitionID):
            return "/exhibition/create/success/\(exhibitionID)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postExhibitionData, .postArtworkData:
            return .post
        case .getRegisterStatus:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .postExhibitionData(let exhibitionData):
            var multipartData = [MultipartFormData]()
            
            let image = exhibitionData.posterImage?.jpegData(compressionQuality: 1) ?? Data()
            let imageData = MultipartFormData(provider: .data(image), name: "file", fileName: "image.png", mimeType: "image/png")
            multipartData.append(imageData)
            
            for (key, values) in exhibitionData.exhibitionParam {
                let formData = MultipartFormData(provider: .data("\(values)".data(using: .utf8)!), name: key)
                multipartData.append(formData)
            }
            
            return .uploadMultipart(multipartData)
            
        case .postArtworkData(exhibitionID: _, artwork: let artwork):
            var multipartData = [MultipartFormData]()
            
            let image = artwork.image?.jpegData(compressionQuality: 1) ?? Data()
            let imageData = MultipartFormData(provider: .data(image), name: "file", fileName: "image.png", mimeType: "image/png")
            multipartData.append(imageData)
            
            for (key, values) in artwork.artworkParam {
                let formData = MultipartFormData(provider: .data("\(values)".data(using: .utf8)!), name: key)
                multipartData.append(formData)
            }
            
            return .uploadMultipart(multipartData)
            
        case .getRegisterStatus:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["accessToken": TokenInfo.shared.accessToken ?? ""]
    }
}
