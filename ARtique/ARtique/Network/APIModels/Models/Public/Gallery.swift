//
//  Gallery.swift
//  ARtique
//
//  Created by hwangJi on 2022/05/11.
//

import Foundation

// MARK: - Gallery
struct Gallery: Codable {
    let exhibitionID, gallerySize, galleryTheme: Int
    let isPublic: Bool

    enum CodingKeys: String, CodingKey {
        case exhibitionID = "exhibitionId"
        case gallerySize, galleryTheme, isPublic
    }
}
