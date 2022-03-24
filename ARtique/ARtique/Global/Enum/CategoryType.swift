//
//  CategoryType.swift
//  ARtique
//
//  Created by 황윤경 on 2022/03/25.
//

import UIKit

enum CategoryType: CaseIterable {
    case contemporaryArt
    case illustration
    case daily
    case pet
    case fan
}

extension CategoryType {
    var categoryTitle: String {
        switch self {
        case .contemporaryArt:
            return "현대미술"
        case .illustration:
            return "일러스트"
        case .daily:
            return "일상"
        case .pet:
            return "반려동물"
        case .fan:
            return "팬 문화"
        }
    }
}
