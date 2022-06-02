//
//  TicketHeaderCVC.swift
//  ARtique
//
//  Created by hwangJi on 2022/05/18.
//

import UIKit

class TicketHeaderCVC: BaseCell {
    
    // MARK: Properties
    private let thumbImageView = UIImageView().then {
        $0.image = UIImage(named: "ticket_thumb")
        $0.contentMode = .scaleAspectFit
    }
    private let titleLabel = UILabel().then {
        $0.font = UIFont.AppleSDGothicR(size: 14.0)
        $0.textColor = UIColor.black
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.sizeToFit()
    }
    private let bottomBarView = UIView().then {
        $0.backgroundColor = .gray1
    }
    
    // MARK: Variables
    var isDeleteMode: Bool = false
    
    override func setupViews() {
        configureUI()
    }
}

// MARK: - UI
extension TicketHeaderCVC {
    private func configureUI() {
        self.addSubviews([thumbImageView, titleLabel, bottomBarView])
       
        thumbImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(13)
            $0.width.height.equalTo(50)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(thumbImageView.snp.trailing).offset(19)
            $0.centerY.equalTo(thumbImageView)
        }
        
        bottomBarView.snp.makeConstraints {
            $0.top.equalTo(thumbImageView.snp.bottom).offset(19)
            $0.leading.equalTo(self).offset(20)
            $0.trailing.equalTo(self).inset(20)
            $0.height.equalTo(1)
        }
    }
}

// MARK: - Custom Methods
extension TicketHeaderCVC {
    func setData(model: [TicketListModel]) {
        titleLabel.text = (UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) ?? "") + "ARTI\n벌써 \(model.count)개의 티켓을 모았어요!"
    }
    
    /// 삭제 모드에 따라 뷰의 opacity를 설정하는 메서드
    func setUpCellbyMode(isDeleteMode: Bool) {
        thumbImageView.layer.opacity = isDeleteMode ? 0.5 : 1
        titleLabel.layer.opacity = isDeleteMode ? 0.5 : 1
    }
}
