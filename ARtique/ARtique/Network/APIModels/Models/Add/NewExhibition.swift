//
//  NewExhibition.swift
//  ARtique
//
//  Created by 황윤경 on 2022/03/26.
//

import UIKit
import Alamofire

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
    var artworks: [ArtworkData]?
    
    private init() { }
}

extension NewExhibition {
    var exhibitionParam: Parameters {
        return [
            "gallerySize": gallerySize!,
            "galleryTheme": galleryTheme!,
            "title": title!,
            "category": category!,
            "description": description!,
            "tag": tag!,
            "isPublic": isPublic!
        ]
    }
}
