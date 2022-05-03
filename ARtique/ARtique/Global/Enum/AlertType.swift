//
//  AlertType.swift
//  ARtique
//
//  Created by 황윤경 on 2022/05/01.
//

import Foundation
import UIKit

enum AlertType: CaseIterable {
    case removeAllExhibition
    case registerExhibition
}

extension AlertType {
    var alertImage: UIImage {
        switch self {
        case .removeAllExhibition:
            return UIImage(named: "WarningAlert") ?? UIImage()
        case .registerExhibition:
            return UIImage(named: "ConfirmAlert") ?? UIImage()
        }
    }
    
    var message: NSMutableAttributedString {
        let fontSize = UIFont.AppleSDGothicB(size: 16)
        switch self {
        case .removeAllExhibition:
            let text = "지금까지 등록한 전시 내용이\n모두 삭제됩니다.\n정말 나가시겠습니까?"
            let attributedStr = NSMutableAttributedString(string: text)
            attributedStr.addAttribute(.font, value: fontSize, range: (text as NSString).range(of: "모두 삭제"))
            return attributedStr
        case .registerExhibition:
            let text = "전시를 지금 바로 등록하시겠습니까?\n등록 후 수정은 일부만 가능합니다."
            let attributedStr = NSMutableAttributedString(string: text)
            attributedStr.addAttribute(.font, value: fontSize, range: (text as NSString).range(of: "지금 바로 등록"))
            return attributedStr
        }
    }
    
    var leftBtnLabel: String {
        switch self {
        case .removeAllExhibition:
            return "나가기"
        case .registerExhibition:
            return "취소"
        }
    }
    
    var rightBtnLabel: String {
        switch self {
        case .removeAllExhibition:
            return "계속하기"
        case .registerExhibition:
            return "등록하기"
        }
    }
}
