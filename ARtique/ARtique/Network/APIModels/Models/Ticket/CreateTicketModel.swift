//
//  CreateTicketModel.swift
//  ARtique
//
//  Created by hwangJi on 2022/05/18.
//

import Foundation

// MARK: - CreateTicketModel
struct CreateTicketModel: Codable {
    let exhibitionID: Int

    enum CodingKeys: String, CodingKey {
        case exhibitionID = "exhibitionId"
    }
}
