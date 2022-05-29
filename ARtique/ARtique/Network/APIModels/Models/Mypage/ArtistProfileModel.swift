//
//  ArtistProfileModel.swift
//  ARtique
//
//  Created by 황윤경 on 2022/05/24.
//

import Foundation

struct ArtistProfileModel: Codable {
    let user: ArtistProfile
}

struct ArtistProfile: Codable {
    let nickname: String
    let profileImage: String
    let introduction: String
    let website: String
    let exhibitionCount: Int?
    let ticketCount: Int?
}
