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
    var categoryId: Int {
        switch self {
        case .contemporaryArt:
            return 1
        case .illustration:
            return 2
        case .daily:
            return 3
        case .pet:
            return 4
        case .fan:
            return 5
        }
    }
    
    var categoryTitle: String {
        switch self {
        case .contemporaryArt:
            return "전문예술"
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
    
    var viewControllerType: TypeOfViewController {
        .category
    }
}
