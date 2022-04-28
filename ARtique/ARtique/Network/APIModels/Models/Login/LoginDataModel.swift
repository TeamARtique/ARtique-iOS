//
//  LoginDataModel.swift
//  ARtique
//
//  Created by hwangJi on 2022/04/27.
//

import Foundation

// MARK: - LoginDataModel
struct LoginDataModel: Codable {
    let user: LoginUser
    let token: Token
}

// MARK: - LoginUser
struct LoginUser: Codable {
    let userID: Int
    let email, nickname: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case email, nickname
    }
}
