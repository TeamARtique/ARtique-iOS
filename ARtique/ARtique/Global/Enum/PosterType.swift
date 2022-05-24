//
//  PosterType.swift
//  ARtique
//
//  Created by 황윤경 on 2022/05/16.
//

import UIKit

enum PosterType: CaseIterable {
    case theme0
    case theme1
    case theme2
    case theme3
    case theme4
    case theme5
    case theme6
    case theme7
    case theme8
    case theme9
    case theme10
    case theme11
    case theme12
}

extension PosterType {
    var overlay: UIImage {
        switch self {
        case .theme0, .theme1, .theme2:
            return UIImage()
        case .theme3:
            return UIImage(named: "template3") ?? UIImage()
        case .theme4:
            return UIImage(named: "template4") ?? UIImage()
        case .theme5:
            return UIImage(named: "template5") ?? UIImage()
        case .theme6:
            return UIImage(named: "template6") ?? UIImage()
        case .theme7:
            return UIImage(named: "template7") ?? UIImage()
        case .theme8:
            return UIImage(named: "template8") ?? UIImage()
        case .theme9:
            return UIImage(named: "template9") ?? UIImage()
        case .theme10:
            return UIImage(named: "template10") ?? UIImage()
        case .theme11:
            return UIImage(named: "template11") ?? UIImage()
        case .theme12:
            return UIImage(named: "template12") ?? UIImage()
        }
    }
    
    var titleFont: UIFont {
        switch self {
        case .theme0:
            return .AppleSDGothicH(size: 0)
        default:
            return .AppleSDGothicH(size: 30)
        }
    }
    
    var contentFont: UIFont {
        switch self {
        case .theme1, .theme2,.theme3, .theme4:
            return .AppleSDGothicSB(size: 15)
        case .theme5, .theme6, .theme7, .theme8,.theme9, .theme10, .theme11, .theme12:
            return .AppleSDGothicSB(size: 13)
        default:
            return .AppleSDGothicR(size: 0)
        }
    }
    
    var titleColor: UIColor {
        switch self {
        case .theme1, .theme3, .theme5, .theme8, .theme9, .theme11:
            return .black
        default:
            return .white
        }
    }
    
    var contentColor: UIColor {
        switch self {
        case .theme1, .theme3, .theme5, .theme7, .theme9, .theme11:
            return .black
        default:
            return .white
        }
    }
}
