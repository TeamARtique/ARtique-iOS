//
//  NewExhibition.swift
//  ARtique
//
//  Created by 황윤경 on 2022/03/26.
//

import UIKit

class NewExhibition {
    static let shared = NewExhibition()
    
    var artworkCnt: Int?
    var themeId: Int?
    var selectedArtwork: [UIImage]?
    var artworkTitle: [String]?
    var artworkExplain: [String]?
    var title: String?
    var categoryId: Int?
    var phosterId: Int?
    var exhibitionExplain: String?
    var tagId: [Int]?
    var isPublic: Bool?
    
    private init() { }
}
