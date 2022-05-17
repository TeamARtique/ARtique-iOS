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
            "gallerySize": gallerySize ?? 5,
            "galleryTheme": galleryTheme ?? 1,
            "title": title ?? "",
            "category": category ?? 1,
            "description": description ?? "",
            "tag": tag ?? [0],
            "isPublic": isPublic ?? false
        ]
    }
}
