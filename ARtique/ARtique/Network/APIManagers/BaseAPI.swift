//
//  BaseAPI.swift
//  ARtique
//
//  Created by hwangJi on 2022/04/27.
//

import Foundation

class BaseAPI {
    
    // MARK: Judge
    func judgeStatus<T: Codable>(type: T.Type, by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodeData = try? decoder.decode(GenericResponse<T>.self, from: data) else {
            return .pathErr
        }
        switch statusCode {
        case 200: return .success(decodeData.data ?? "None-Data")
        case 400...409: return .requestErr(decodeData)
        case 500: return .serverErr
        default:
            return .networkFail
        }
    }
}
