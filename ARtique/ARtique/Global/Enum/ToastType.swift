//
//  ToastType.swift
//  ARtique
//
//  Created by 황윤경 on 2022/05/20.
//

import UIKit

enum ToastType: String {
    case chooseAll
    case photoLimit
    case textLimit
    case deleteExhibition
    case choosePoster
    case exhibitionEdited
}

extension ToastType {
    var message: String {
        switch self {
        case .chooseAll:
            return "모든 항목의 선택을 완료해주세요."
        case .photoLimit:
            return "사진은 N개까지 선택할 수 있습니다."
        case .textLimit:
            return "전시회 설명은 100자까지 입력할 수 있습니다."
        case .deleteExhibition:
            return "전시가 삭제되었습니다."
        case .choosePoster:
            return "변경할 포스터 이미지를 선택해주세요"
        case .exhibitionEdited:
            return "전시 정보가 수정되었습니다."
        }
    }
    
    var topOffset: CGFloat {
        switch self {
        case .choosePoster, .exhibitionEdited:
            return 62
        default:
            return 106
        }
    }
}
