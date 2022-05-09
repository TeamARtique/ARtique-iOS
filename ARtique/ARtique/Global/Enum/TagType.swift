//
//  TagType.swift
//  ARtique
//
//  Created by 황윤경 on 2022/03/28.
//

import UIKit

enum TagType: CaseIterable {
    case modern
    case lovely
    case vintage
    case dynamic
    case serene
    case cute
    case cozy
    case free
}

extension TagType {
    var tagTitle: String {
        switch self {
        case .modern:
            return "#모던한"
        case .lovely:
            return "#사랑스러운"
        case .vintage:
            return "#빈티지한"
        case .dynamic:
            return "#자유로운"
        case .serene:
            return "#고요한"
        case .cute:
            return "#아기자기한"
        case .cozy:
            return "#포근한"
        case .free:
            return "#다이나믹한"
        }
    }
}
