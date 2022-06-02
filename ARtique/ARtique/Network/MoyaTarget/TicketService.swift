//
//  TicketService.swift
//  ARtique
//
//  Created by hwangJi on 2022/05/18.
//

import Foundation
import Moya

enum TicketService {
    case createTicketbook(exhibitionID: Int)
    case getTicketbook
    case deleteTicketbook(exhibitionID: Int)
}

extension TicketService: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    var path: String {
        switch self {
        case .createTicketbook(let exhibitionID):
            return "/ticket/\(exhibitionID)"
        case .getTicketbook:
            return "/ticket"
        case .deleteTicketbook(let exhibitionID):
            return "/ticket/delete/\(exhibitionID)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createTicketbook:
            return .post
        case .getTicketbook:
            return .get
        case .deleteTicketbook:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .createTicketbook, .getTicketbook, .deleteTicketbook:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["accessToken": TokenInfo.shared.accessToken ?? ""]
    }
}
