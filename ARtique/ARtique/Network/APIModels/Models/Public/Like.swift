//
//  Like.swift
//  ARtique
//
//  Created by hwangJi on 2022/04/27.
//

import Foundation

// MARK: - Like
struct Like: Codable {
    let isLiked: Bool
    let likeCount: Int
}

extension Like {
    var likeCnt: String {
        return likeCount > 99 ? "99+" : "\(likeCount)"
    }
}
