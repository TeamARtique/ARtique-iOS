//
//  LatestSearchedCVC.swift
//  ARtique
//
//  Created by 황윤경 on 2022/04/16.
//

import UIKit

class LatestSearchedCVC: UICollectionViewCell {
    @IBOutlet weak var contentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override var isSelected: Bool {
        didSet{
            if isSelected {
                contentLabel.textColor = .white
                backgroundColor = .black
            }
            else {
                contentLabel.textColor = .black
                backgroundColor = .white
            }
        }
    }
    
    func configureCell(with label: String) {
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = frame.height / 2
        
        contentLabel.font = .AppleSDGothicL(size: 13)
        contentLabel.text = "\(label)"
    }
}
