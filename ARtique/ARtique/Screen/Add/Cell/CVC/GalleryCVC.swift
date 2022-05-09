//
//  GalleryCVC.swift
//  ARtique
//
//  Created by 황윤경 on 2022/03/22.
//

import UIKit
import SnapKit
import Then

class GalleryCVC: BorderCVC {
    private var indexBase = UIView()
        .then {
            $0.backgroundColor = .gray4
            $0.layer.cornerRadius = 8
        }
    
    var selectedIndex = UILabel()
        .then {
            $0.textColor = .white
            $0.font = .AppleSDGothicSB(size: 10)
        }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureContentView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureContentView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override var isSelected: Bool {
        didSet{
            if isSelected {
                indexBase.isHidden = false
            }
            else {
                indexBase.isHidden = true
            }
        }
    }
}

// MARK: - Custom Methods
extension GalleryCVC {
    private func configureContentView() {
        contentView.addSubview(indexBase)
        indexBase.addSubview(selectedIndex)
        
        indexBase.snp.makeConstraints {
            $0.width.height.equalTo(16)
            $0.top.equalToSuperview().offset(6)
            $0.trailing.equalToSuperview().offset(-6)
        }
        
        selectedIndex.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        indexBase.isHidden = true
    }

    func configureCell(with artwork: UIImage) {
        configureCell(image: artwork, borderWidth: 3)
    }
    
    func setSelectedIndex(_ index: Int) {
        indexBase.isHidden = false
        selectedIndex.text = "\(index)"
    }
}
