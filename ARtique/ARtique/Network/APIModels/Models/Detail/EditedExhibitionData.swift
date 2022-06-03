//
//  EditedExhibitionData.swift
//  ARtique
//
//  Created by 황윤경 on 2022/06/02.
//

import UIKit
import Alamofire

class EditedExhibitionData {
    var title: String
    var posterURL: String
    var posterOriginalURL: String
    var posterTheme: Int
    var description: String
    var tag: [Int]
    var category: Int
    var isPublic: Bool
    
    init(title: String, posterURL: String, posterOriginalURL: String, posterTheme: Int, description: String, tag: [Int], category: Int, isPublic: Bool) {
        self.title = title
        self.posterURL = posterURL
        self.posterOriginalURL = posterOriginalURL
        self.posterTheme = posterTheme
        self.description = description
        self.tag = tag
        self.category = category
        self.isPublic = isPublic
    }
}

extension EditedExhibitionData {
    var editedExhibitionParam: Parameters {
        return [
            "title": title,
            "category": category,
            "posterImage": posterURL,
            "posterOriginalImage": posterOriginalURL,
            "posterTheme": posterTheme,
            "description": description,
            "tag": tag,
            "isPublic": isPublic
        ]
    }
}
