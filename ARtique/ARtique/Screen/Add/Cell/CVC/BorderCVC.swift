//
//  BorderCVC.swift
//  ARtique
//
//  Created by 황윤경 on 2022/05/05.
//

import UIKit
import SnapKit
import Then

class BorderCVC: UICollectionViewCell {
    private var imageView = UIImageView()
        .then {
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
        }
    
    private var selectedOverlay = UIView()
        .then {
            $0.backgroundColor = .white
            $0.layer.opacity = 0.6
        }
    
    private var posterOverlay = UIImageView()
    
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
        didSet {
            if isSelected {
                imageView.layer.borderColor = UIColor.black.cgColor
                posterOverlay.layer.borderColor = UIColor.black.cgColor
                selectedOverlay.isHidden = false
            }
            else {
                imageView.layer.borderColor = UIColor.clear.cgColor
                posterOverlay.layer.borderColor = UIColor.clear.cgColor
                selectedOverlay.isHidden = true
            }
        }
    }
    
    private func configureContentView() {
        contentView.addSubview(imageView)
        contentView.addSubview(posterOverlay)
        contentView.addSubview(selectedOverlay)
        
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        selectedOverlay.isHidden = true
    }
    
    func configureCell(image: UIImage, borderWidth: CGFloat) {
        imageView.image = image
        imageView.layer.borderWidth = borderWidth
        posterOverlay.layer.borderWidth = borderWidth
        
        selectedOverlay.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(borderWidth)
            $0.bottom.trailing.equalToSuperview().offset(-borderWidth)
        }
    }
    
    func configurePosterCell(image: UIImage, overlay: UIImage, borderWidth: CGFloat) {
        configureCell(image: image, borderWidth: borderWidth)
        
        posterOverlay.image = overlay
        posterOverlay.layer.borderColor = UIColor.clear.cgColor
        posterOverlay.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setSelectedOverlay(isEditing: Bool) {
        selectedOverlay.isHidden = !isEditing
        selectedOverlay.layer.opacity = 0.75
    }
}
