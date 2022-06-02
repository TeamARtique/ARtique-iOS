//
//  TicketCVC.swift
//  ARtique
//
//  Created by hwangJi on 2022/05/18.
//

import UIKit
import SnapKit
import Then
import Kingfisher

class TicketCVC: BaseCell {
    
    // MARK: Properties
    private let maskedImageView = UIImageViewWithMask().then {
        $0.maskImage = UIImage(named: "ticketFrame")
        $0.contentMode = .scaleAspectFill
    }
    private let imageDimmedView = UIView().then {
        $0.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
    }
    private let logoImageView = UIImageView().then {
        $0.image = UIImage(named: "artique_logo_white")
    }
    private let squareBorderView = UIView().then {
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.white.cgColor
    }
    private let titleLabel = UILabel().then {
        $0.font = UIFont.KoPubWorldBatangM(size: 12.0)
        $0.textColor = UIColor.white
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.sizeToFit()
    }
    private let highlightView = UIView().then {
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.white.cgColor
    }
    private let artistLabel = UILabel().then {
        $0.font = UIFont.AppleSDGothicL(size: 9.0)
        $0.textColor = UIColor.white
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.sizeToFit()
    }
    private let instaBtn = UIButton().then {
        $0.setImage(UIImage(named: "btn_insta"), for: .normal)
    }
    private let deleteBtn = UIButton().then {
        $0.setImage(UIImage(named: "btn_deleteticket"), for: .normal)
        $0.isHidden = true
    }
    
    // MARK: Variables
    var isDeleteMode: Bool?
    var tapDeleteBtnAction: (() -> ())?
    
    override func setupViews() {
        configrueUI()
        setUpDeleteBtn()
    }
}

// MARK: - UI
extension TicketCVC {
    private func configrueUI() {
        self.addSubviews([maskedImageView, logoImageView, squareBorderView, titleLabel, highlightView, artistLabel, instaBtn, deleteBtn])
        
        maskedImageView.addSubview(imageDimmedView)
        
        maskedImageView.snp.makeConstraints {
            $0.top.equalTo(self).offset(5)
            $0.trailing.equalTo(self).inset(5)
            $0.leading.bottom.equalTo(self)
        }
        
        imageDimmedView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(maskedImageView)
        }
        
        logoImageView.snp.makeConstraints {
            $0.top.equalTo(maskedImageView.snp.top).offset(16)
            $0.leading.equalTo(maskedImageView.snp.leading).offset(7)
            $0.width.equalTo(23)
            $0.height.equalTo(6)
        }
        
        squareBorderView.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(5)
            $0.leading.equalTo(maskedImageView).offset(6)
            $0.trailing.equalTo(maskedImageView).inset(6)
            $0.bottom.equalTo(maskedImageView).inset(16)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(squareBorderView.snp.top).offset(11)
            $0.leading.equalTo(squareBorderView.snp.leading).offset(13)
            $0.trailing.equalTo(squareBorderView.snp.trailing).inset(13)
        }
        
        highlightView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalTo(squareBorderView.snp.leading).offset(5)
            $0.trailing.equalTo(squareBorderView.snp.trailing).inset(5)
            $0.height.equalTo(0.5)
        }
        
        artistLabel.snp.makeConstraints {
            $0.top.equalTo(highlightView.snp.bottom).offset(8)
            $0.leading.equalTo(squareBorderView.snp.leading).offset(13)
            $0.trailing.equalTo(squareBorderView.snp.trailing).inset(13)
            $0.bottom.lessThanOrEqualTo(squareBorderView.snp.bottom).inset(4)
        }
        
        instaBtn.snp.makeConstraints {
            $0.bottom.equalTo(squareBorderView.snp.bottom).inset(4)
            $0.trailing.equalTo(squareBorderView.snp.trailing).inset(4)
            $0.width.height.equalTo(10)
        }
        
        deleteBtn.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
            $0.width.height.equalTo(16)
        }
    }
    
    private func setupMaskedImageView() {
        maskedImageView.maskImage = UIImage(named: "ticketFrame")
        
        let tintView = UIView()
        tintView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        tintView.frame = CGRect(x: 0, y: 0, width: maskedImageView.frame.width, height: maskedImageView.frame.height)
        
        maskedImageView.addSubview(tintView)
    }
}

// MARK: - Custom Methods
extension TicketCVC {
    func setData(model: TicketListModel) {
        titleLabel.text = model.title
        artistLabel.text = model.nickname
        downloadImage(with: model.posterImage)
    }
    
    private func downloadImage(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let resource = ImageResource(downloadURL: url)
        
        DispatchQueue.global().async {
            KingfisherManager.shared.retrieveImage(with: resource,
                                                   options: nil,
                                                   progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    DispatchQueue.main.async {
                        self.maskedImageView.image = value.image
                    }
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
    }
    
    /// 셀 삭제 버튼을 눌렀을 때 액션 set 메서드
    private func setUpDeleteBtn() {
        deleteBtn.press(vibrate: true, for: .touchUpInside) {
            self.tapDeleteBtnAction?()
        }
    }
    
    /// 삭제 모드에 따라 삭제 버튼의 숨김상태를 설정하는 메서드
    func setUpDeleteBtnbyMode(isDeleteMode: Bool) {
        deleteBtn.isHidden = isDeleteMode ? false : true
    }
}
