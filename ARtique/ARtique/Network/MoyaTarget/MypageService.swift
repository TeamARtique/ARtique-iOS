//
//  MypageService.swift
//  ARtique
//
//  Created by 황윤경 on 2022/05/24.
//

import Foundation
import Moya

enum MypageService {
    case getMypageData
    case editProfile(artist: ArtistModel)
    case getArtistProfile(artistID: Int)
    case postWithdrawal
    case getMyExhibition
    case getBookmarkedExhibition
}

extension MypageService: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getMypageData:
            return "/mypage"
        case .editProfile:
            return "/mypage/profile"
        case .getArtistProfile(let artistID):
            return "/artist/\(artistID)"
        case .postWithdrawal:
            return "/user/delete"
        case .getMyExhibition:
            return "/mypage/exhibition"
        case .getBookmarkedExhibition:
            return "/mypage/bookmark"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getMypageData, .getArtistProfile, .getMyExhibition, .getBookmarkedExhibition:
            return .get
        case .editProfile:
            return .put
        case .postWithdrawal:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getMypageData, .getArtistProfile, .postWithdrawal, .getMyExhibition, .getBookmarkedExhibition:
            return .requestPlain
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
