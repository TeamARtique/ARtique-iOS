//
//  ExhibitionCntBtn.swift
//  ARtique
//
//  Created by 황윤경 on 2022/04/23.
//

import UIKit

class ExhibitionCntBtn: UIButton {
    let title = UILabel()
        .then {
            $0.textAlignment = .center
            $0.font = .AppleSDGothicL(size: 12)
        }
    
    let exhibitionCnt = UILabel()
        .then {
            $0.textAlignment = .center
            $0.font = .AppleSDGothicB(size: 17)
        }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureBtn()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureBtn()
    }
    
    private func configureBtn() {
        addSubview(title)
        title.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.leading.trailing.equalToSuperview()
        }
        
        addSubview(exhibitionCnt)
        exhibitionCnt.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-11)
            $0.leading.trailing.equalToSuperview()
        }
    }
}
