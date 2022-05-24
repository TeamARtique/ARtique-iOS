//
//  ArtistModel.swift
//  ARtique
//
//  Created by 황윤경 on 2022/05/24.
//

import UIKit
import Alamofire

struct ArtistModel {
    let nickname: String
    let profileImage: UIImage
    let introduction: String
    let website: String
}

extension ArtistModel {
    var profileParam: Parameters {
        return [
            "nickname": nickname,
            "introduction": introduction,
            "website": website
        ]
    }
}
