//
//  Token.swift
//  ARtique
//
//  Created by hwangJi on 2022/04/28.
//

import Foundation

// MARK: - Token
struct Token: Codable {
    let accessToken: String
    let refreshToken: String
}
