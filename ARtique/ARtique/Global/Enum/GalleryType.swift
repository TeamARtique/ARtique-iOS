//
//  GalleryType.swift
//  ARtique
//
//  Created by hwangJi on 2022/03/19.
//

import Foundation

enum GalleyType: Int {
    case minimum = 5
    case medium = 12
    case maximum = 30
}

extension GalleyType {
    var galleryModelIdentifier: String {
        switch self {
        case .minimum:
            return Identifiers.minimumGalleryModel
        case .medium:
            return Identifiers.mediumGalleryModel
        case .maximum:
            return Identifiers.maximumGalleryModel
        }
    }
    
    var galleryScenePath: String {
        switch self {
        case .minimum:
            return Identifiers.minimumGalleryScenePath
        case .medium:
            return Identifiers.mediumGalleryScenePath
        case .maximum:
            return Identifiers.maximumGalleryScenePath
        }
    }
    
    /// 액자 프레임 Identifier
    var frameIdentifier1: String {
        switch self {
        case .minimum:
            return Identifiers.minimumFrame
        case .medium:
            return Identifiers.mediumFrame
        case .maximum:
            return Identifiers.maximumUpFrame
        }
    }
    
    /// 액자 프레임 Identifier2 -> maximum model에서 1층 프레임 Identifier를 구분짓기 위해 사용
    var frameIdentifier2: String {
        switch self {
        case .minimum, .medium:
            return ""
        case .maximum:
            return Identifiers.maximumDownFrame
        }
    }
}
