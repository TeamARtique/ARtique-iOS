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
    var posterImage: UIImage
//    var posterTheme: Int?
    var description: String
    var tag: [Int]
    var category: Int
    var isPublic: Bool
    
    init(title: String, posterImage: UIImage, description: String, tag: [Int], category: Int, isPublic: Bool) {
        self.title = title
        self.posterImage = posterImage
        // TODO: - 서버에 포스터 테마 추가 후 수정
//        self.posterTheme = exhibitionData.posterTheme ?? 0
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
            "description": description,
            "tag": tag,
            "isPublic": isPublic
        ]
    }
}
