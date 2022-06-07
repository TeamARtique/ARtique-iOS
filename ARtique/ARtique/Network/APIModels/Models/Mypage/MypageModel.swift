//
//  MypageModel.swift
//  ARtique
//
//  Created by 황윤경 on 2022/05/29.
//

import Foundation

struct MypageModel: Codable {
    let user: ArtistProfile
    let myExhibitionCount: Int
    let myExhibition: [ExhibitionModel]
    let myBookmarkCount: Int
    let myBookmarkedData : [ExhibitionModel]
}
