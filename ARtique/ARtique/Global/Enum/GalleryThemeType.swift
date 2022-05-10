//
//  GalleryThemeType.swift
//  ARtique
//
//  Created by hwangJi on 2022/05/03.
//

import Foundation
import UIKit

enum GalleryThemeType: Int {
    case white = 1
    case dark = 2
    case container = 3
    case antique = 4
}

extension GalleryThemeType {
    
    /// 갤러리 모델 배경색 or 이미지
    var galleryModelMaterial: Any {
        switch self {
        case .white:
            return UIColor.white
        case .dark:
            return UIColor.darkModel
        case .container:
            return UIImage(named: "art.scnassets/GalleryAsset/container.png") ?? UIImage()
        case .antique:
            return UIImage(named: "art.scnassets/GalleryAsset/wood.png") ?? UIImage()
        }
    }
    
   /// 액자 프레임 색
    var frameColor: UIColor {
        switch self {
        case .white:
            return .black
        case .dark:
            return .black
        case .container:
            return .white
        case .antique:
            return .antiqueFrame
        }
    }
    
    /// 조명 색
    var lightColor: UIColor {
        switch self {
        case .white, .dark, .container:
            return .white
        case .antique:
            return .antiqueLight
        }
    }
    
    /// 타이틑 텍스트 색
    var textColor: UIColor {
        switch self {
        case .white:
            return .defaultText
        case .dark:
            return .darkText
        case .container:
            return .white
        case .antique:
            return .antiqueText
        }
    }
}

