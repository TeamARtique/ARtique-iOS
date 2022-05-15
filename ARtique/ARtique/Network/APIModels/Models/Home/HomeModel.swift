//
//  HomeModel.swift
//  ARtique
//
//  Created by 황윤경 on 2022/05/15.
//

import Foundation

struct HomeModel: Codable {
    let forArtiExhibition: [ExhibitionModel]
    let popularExhibition: [ExhibitionModel]
    let categoryExhibition: [ExhibitionModel]
}
