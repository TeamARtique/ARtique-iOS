//
//  ExhibitionModel.swift
//  ARtique
//
//  Created by 황윤경 on 2022/05/15.
//

import UIKit

struct ExhibitionModel: Codable {
    var exhibitionId: Int?
    var title: String?
    var posterImage: String?
    var posterOriginalImage: String?
    var posterTheme: Int?
    var artist: Artist?
    var like: Like?
    var bookmark: Bookmark?
    var createdAt: String?
    var description: String?
    var tag: [Int]?
    var category: Int?
    var gallerySize: Int?
    var galleryTheme: Int?
    var isPublic: Bool?
}

extension ExhibitionModel {
    var posterImgURL: URL? {
        guard let posterImgURL = posterImage else { return nil }
        let encodedStr = posterImgURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: encodedStr)!
        return url
    }
    
    var date: String? {
        guard let createdAt = createdAt,
              let first = createdAt.split(separator: "T").first else {
                  return nil
              }
        
        return String(first).toDate()?.toString()
    }
}
