//
//  AddProcess.swift
//  ARtique
//
//  Created by 황윤경 on 2022/03/16.
//

import UIKit

enum AddProcess: CaseIterable {
    case theme
    case gallery
    case order
    case photoExplaination
    case exhibitionExplaination
}

extension AddProcess {
    var naviTitle: String {
        switch self {
        case .theme:
            return "전시 등록"
        case .gallery:
            return "사진 선택 (\(NewExhibition.shared.selectedArtwork?.count ?? 0)/\(NewExhibition.shared.artworkCnt ?? 0))"
        case .order:
            return "순서 조정"
        case .photoExplaination:
            return "작품 설명"
        case .exhibitionExplaination:
            return "전시 등록"
        }
    }
}
