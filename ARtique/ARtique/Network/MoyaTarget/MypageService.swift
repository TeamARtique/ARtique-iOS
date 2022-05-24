//
//  MypageService.swift
//  ARtique
//
//  Created by 황윤경 on 2022/05/24.
//

import Foundation
import Moya

enum MypageService {
    case editProfile(artist: ArtistModel)
}

extension MypageService: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    var path: String {
        switch self {
        case .editProfile:
            return "/mypage/profile"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .editProfile:
            return .put
        }
    }
    
    var task: Task {
        switch self {
        case .editProfile(let artist):
            var multipartData = [MultipartFormData]()
            
            let image = artist.profileImage.jpegData(compressionQuality: 1) ?? Data()
            let imageData = MultipartFormData(provider: .data(image), name: "file", fileName: "image.png", mimeType: "image/png")
            multipartData.append(imageData)
            
            for (key, values) in artist.profileParam {
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
