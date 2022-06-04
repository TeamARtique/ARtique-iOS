//
//  EmptyCVC.swift
//  ARtique
//
//  Created by hwangJi on 2022/06/04.
//

import UIKit
import Then
import SnapKit

class EmptyCVC: BaseCell {
    
    // MARK: Properties
    private let titleLabel = UILabel().then {
        $0.font = UIFont.AppleSDGothicL(size: 14.0)
        $0.textColor = UIColor.black
        $0.text = """
        ARtique를 둘러보며
        마음에 드는 AR전시를 체험해
        첫 번째 티켓을 모아보세요!
        """
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.sizeToFit()
    }
    
    override func setupViews() {
        configrueUI()
    }
}

// MARK: - UI
extension EmptyCVC {
    private func configrueUI() {
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.centerX.centerY.equalTo(contentView)
        }
    }
}
