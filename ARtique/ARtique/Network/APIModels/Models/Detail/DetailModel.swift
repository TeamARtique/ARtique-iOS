//
//  DetailModel.swift
//  ARtique
//
//  Created by 황윤경 on 2022/05/17.
//

import Foundation

struct DetailModel: Codable {
    let exhibition: ExhibitionModel
    let artist: Artist
    let like: Like
    let bookmark: Bookmark
}
