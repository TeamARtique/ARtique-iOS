//
//  Artist.swift
//  ARtique
//
//  Created by 황윤경 on 2022/05/15.
//

import Foundation

struct Artist: Codable {
    let artistId: Int
    let nickname: String
    var isWritter: Bool?
    var profileImage: String?
}

extension Artist {
    var profileImgURL: URL? {
        guard let profileImgURL = profileImage else { return nil }
        let encodedStr = profileImgURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: encodedStr)!
        return url
    }
}
