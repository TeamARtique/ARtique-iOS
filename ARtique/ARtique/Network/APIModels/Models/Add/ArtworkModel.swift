//
//  ArtworkModel.swift
//  ARtique
//
//  Created by 황윤경 on 2022/05/17.
//

import Foundation

struct ArtworkModel: Codable {
    let exhibitionId: Int
    let artworkId: Int
    let image: String
    let title: String
    let description: String
    let index: Int
}
