//
//  ArtworkData.swift
//  ARtique
//
//  Created by 황윤경 on 2022/05/17.
//

import UIKit
import Alamofire

class ArtworkData {
    var image: UIImage?
    var title: String?
    var description: String?
    var index: Int?
}

extension ArtworkData {
    var artworkParam: Parameters {
        return [
            "title": title ?? "",
            "description": description ?? "",
            "index": index ?? 0
        ]
    }
}
