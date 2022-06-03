//
//  UserDefaults+.swift
//  ARtique
//
//  Created by 황지은 on 2021/11/29.
//

import Foundation
extension UserDefaults {
    enum Keys {
        static var userID = "userID"
        static var userEmail = "userEmail"
        static var nickname = "nickname"
        static var refreshToken = "refreshToken"
        static var completeSignup = "completeSignup"
        static var reconnect = "reconnect"
    }
}
