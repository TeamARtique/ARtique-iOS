//
//  ThemeType.swift
//  ARtique
//
//  Created by 황윤경 on 2022/05/05.
//

import UIKit

enum ThemeType: CaseIterable {
    case white
    case dark
    case container
    case antique
}

extension ThemeType {
    var themeId: Int {
        switch self {
        case .white:
            return 1
        case .dark:
            return 2
        case .container:
            return 3
        case .antique:
            return 4
        }
    }
    
    var themeTitle: String {
        switch self {
        case .white:
            return "화이트"
        case .dark:
            return "다크"
        case .container:
            return "컨테이너"
        case .antique:
            return "고풍"
        }
    }
    
    var themeImage: UIImage {
        switch self {
        case .white:
            return UIImage(named: "Theme1") ?? UIImage()
        case .dark:
            return UIImage(named: "Theme2") ?? UIImage()
        case .container:
            return UIImage(named: "Theme3") ?? UIImage()
        case .antique:
            return UIImage(named: "Theme4") ?? UIImage()
        }
    }
}
