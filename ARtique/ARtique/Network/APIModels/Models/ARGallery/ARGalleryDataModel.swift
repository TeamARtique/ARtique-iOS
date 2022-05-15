//
//  ARGalleryDataModel.swift
//  ARtique
//
//  Created by hwangJi on 2022/05/11.
//

import Foundation

// MARK: - ARGalleryDataModel
struct ARGalleryDataModel: Codable {
    let gallery: Gallery
    let artworks: [Artwork]
    let like: Like
    let bookmark: Bookmark
}
