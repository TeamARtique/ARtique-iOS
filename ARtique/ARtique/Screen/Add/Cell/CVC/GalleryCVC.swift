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
            $0.layer.cornerRadius = 8
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.white.cgColor
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
        indexBase.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        selectedIndex.textColor = .clear
    }
    
    override var isSelected: Bool {
        didSet{
            if isSelected {
                indexBase.backgroundColor = .gray4
                selectedIndex.textColor = .white
            }
            else {
                indexBase.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
                selectedIndex.textColor = .clear
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
        
        indexBase.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
    }

    func configureCell(with artwork: UIImage) {
        configureCell(image: artwork, borderWidth: 3)
    }
    
    func setSelectedIndex(_ index: Int) {
        indexBase.backgroundColor = .gray4
        selectedIndex.textColor = .white
        selectedIndex.text = "\(index)"
    }
}
