//
//  Bookmark.swift
//  ARtique
//
//  Created by hwangJi on 2022/04/27.
//

import Foundation

// MARK: - Bookmark
struct Bookmark: Codable {
    let isBookmarked: Bool
    let bookmarkCount: Int
}

extension Bookmark {
    var bookmarkCnt: String {
        return bookmarkCount > 99 ? "99+" : "\(bookmarkCount)"
    }
}
