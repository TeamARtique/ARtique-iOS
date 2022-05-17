//
//  NewExhibition.swift
//  ARtique
//
//  Created by 황윤경 on 2022/03/26.
//

import UIKit

class NewExhibition {
    static let shared = NewExhibition()
    
    var title: String?
    var posterImage: UIImage?
    var posterTheme: Int?
    var description: String?
    var tag: [Int]?
    var category: Int?
    var gallerySize: Int?
    var galleryTheme: Int?
    var isPublic: Bool?
    var artworkIndex = [Int]()
    var artworks: [UIImage]?
    var artworkTitle: [String]?
    var artworkExplain: [String]?
    
    private init() { }
}
