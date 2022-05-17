//
//  RegisterModel.swift
//  ARtique
//
//  Created by 황윤경 on 2022/05/17.
//

import Foundation

struct RegisterModel: Codable {
    let exhibition: ExhibitionModel
}

struct RegisterStatusModel: Codable {
    let exhibition: ExhibitionModel
    let artworks: [ArtworkModel]
}
