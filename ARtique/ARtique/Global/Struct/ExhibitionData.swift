//
//  ExhibitionData.swift
//  ARtique
//
//  Created by 황윤경 on 2021/12/03.
//

import UIKit

struct ExhibitionData {
    var title: String
    var author: String
    var phoster: UIImage
    var tagId: [Int]
    var like: Int
    var bookMark: Int

    init(_ title: String, _ author: String, _ phoster: UIImage, _ tagId: [Int] , _ like: Int, _ bookMark: Int) {
        self.title = title
        self.author = author
        self.phoster = phoster
        self.tagId = tagId
        self.like = like
        self.bookMark = bookMark
    }
}
