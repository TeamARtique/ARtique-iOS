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
    case seeTicketbook
}

extension AlertType {
    var alertImage: UIImage {
        switch self {
        case .removeAllExhibition:
            return UIImage(named: "WarningAlert") ?? UIImage()
        case .registerExhibition:
            return UIImage(named: "ConfirmAlert") ?? UIImage()
        case .seeTicketbook:
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
        case .seeTicketbook:
            let text = "등록된 티켓북을 확인하시겠습니까?\n티켓북은 홈>티켓 아이콘을 통해서도 \n확인 가능합니다."
            let attributedStr = NSMutableAttributedString(string: text)
            attributedStr.addAttribute(.font, value: fontSize, range: (text as NSString).range(of: "지금 바로 확인"))
            return attributedStr
        }
    }
    
    var leftBtnLabel: String {
        switch self {
        case .removeAllExhibition:
            return "나가기"
        case .registerExhibition:
            return "취소"
        case .seeTicketbook:
            return "취소"
        }
    }
    
    var rightBtnLabel: String {
        switch self {
        case .removeAllExhibition:
            return "계속하기"
        case .registerExhibition:
            return "등록하기"
        case .seeTicketbook:
            return "확인하기"
        }
    }
}
