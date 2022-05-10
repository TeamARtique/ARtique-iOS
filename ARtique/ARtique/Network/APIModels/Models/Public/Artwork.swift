//
//  Artwork.swift
//  ARtique
//
//  Created by hwangJi on 2022/05/11.
//

import Foundation

// MARK: - Artwork
struct Artwork: Codable {
    let artworkID: Int
    let image: String
    let title, description: String

    enum CodingKeys: String, CodingKey {
        case artworkID = "artworkId"
        case image, title, description
    }
}
