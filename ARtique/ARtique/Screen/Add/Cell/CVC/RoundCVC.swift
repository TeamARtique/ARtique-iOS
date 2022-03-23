//
//  RoundCVC.swift
//  ARtique
//
//  Created by 황윤경 on 2022/03/16.
//

import UIKit

class RoundCVC: UICollectionViewCell {
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
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
    
    func configureCell(with cnt: Int) {
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = contentView.frame.height / 2
        
        contentLabel.font = .AppleSDGothicM(size: 13)
        contentLabel.text = "\(cnt)개"
    }
}
