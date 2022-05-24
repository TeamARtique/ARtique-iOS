//
//  TicketListModel.swift
//  ARtique
//
//  Created by hwangJi on 2022/05/18.
//

import Foundation

// MARK: - TicketListModel
struct TicketListModel: Codable {
    let exhibitionID: Int
    let title, posterImage, nickname: String

    enum CodingKeys: String, CodingKey {
        case exhibitionID = "exhibitionId"
        case title, posterImage, nickname
    }
}
