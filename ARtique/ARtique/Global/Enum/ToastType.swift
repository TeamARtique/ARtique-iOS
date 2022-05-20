//
//  ToastType.swift
//  ARtique
//
//  Created by 황윤경 on 2022/05/20.
//

import Foundation

enum ToastType: String {
    case chooseAll
    case photoLimit
    case textLimit
}

extension ToastType {
    var position: String {
        switch self {
        case .chooseAll, .photoLimit, .textLimit:
            return "top"
        }
    }
    
    var message: String {
        switch self {
        case .chooseAll:
            return "모든 항목의 선택을 완료해주세요."
        case .photoLimit:
            return "사진은 N개까지 선택할 수 있습니다."
        case .textLimit:
            return "전시회 설명은 100자까지 입력할 수 있습니다."
        }
    }
}
