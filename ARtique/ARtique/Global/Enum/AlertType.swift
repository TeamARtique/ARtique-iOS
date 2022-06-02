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
    case removeAllPhotos
    case registerExhibition
    case seeTicketbook
    case deleteExhibition
    case signupProgress
    case completeSignup
    case deleteTicketbook
}

extension AlertType {
    var alertImage: UIImage {
        switch self {
        case .removeAllExhibition, .removeAllPhotos, .deleteExhibition, .signupProgress, .deleteTicketbook:
            return UIImage(named: "WarningAlert") ?? UIImage()
        case .registerExhibition, .seeTicketbook, .completeSignup:
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
        case .removeAllPhotos:
            let text = "지금까지 등록한 사진에 대한\n내용이 모두 삭제됩니다.\n정말 이전 단계로 이동하겠습니까?"
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
        case .deleteExhibition:
            let text = "전시를\n정말 삭제하시겠습니까?"
            let attributedStr = NSMutableAttributedString(string: text)
            attributedStr.addAttribute(.font, value: fontSize, range: (text as NSString).range(of: "삭제"))
            return attributedStr
        case .signupProgress:
            let text = "입력할 가입 정보가 있습니다.\n계속해서 회원가입을 완료해주세요."
            let attributedStr = NSMutableAttributedString(string: text)
            attributedStr.addAttribute(.font, value: fontSize, range: (text as NSString).range(of: "회원가입을 완료"))
            return attributedStr
        case .completeSignup:
            let text = "회원가입이 완료되었습니다.\nArti가 되신 것을 환영합니다!"
            let attributedStr = NSMutableAttributedString(string: text)
            attributedStr.addAttribute(.font, value: fontSize, range: (text as NSString).range(of: "Arti가 되신 것을 환영"))
            return attributedStr
        case .deleteTicketbook:
            let text = "전시 티켓을\n정말 삭제하시겠습니까?"
            let attributedStr = NSMutableAttributedString(string: text)
            attributedStr.addAttribute(.font, value: fontSize, range: (text as NSString).range(of: "삭제"))
            return attributedStr
        }
    }
    
    var leftBtnLabel: String {
        switch self {
        case .removeAllExhibition, .seeTicketbook:
            return "나가기"
        case .removeAllPhotos:
            return "이전 단계"
        case .registerExhibition:
            return "취소"
        case .deleteExhibition, .deleteTicketbook:
            return "삭제하기"
        case .signupProgress, .completeSignup:
            return ""
        }
    }
    
    var rightBtnLabel: String {
        switch self {
        case .removeAllExhibition, .removeAllPhotos:
            return "취소"
        case .registerExhibition:
            return "등록하기"
        case .seeTicketbook:
            return "확인하기"
        case .deleteExhibition, .deleteTicketbook:
            return "유지하기"
        case .signupProgress:
            return "확인"
        case .completeSignup:
            return "ARtique 시작하기"
        }
    }
    
    var highlight: String {
        switch self {
        case .removeAllExhibition, .removeAllPhotos, .deleteExhibition:
            return "left"
        case .registerExhibition, .seeTicketbook, .signupProgress, .completeSignup, .deleteTicketbook:
            return "right"
        }
    }
}
