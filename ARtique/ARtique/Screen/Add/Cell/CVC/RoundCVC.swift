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
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override var isSelected: Bool {
        didSet{
            if isSelected {
                contentLabel.textColor = .black
                layer.borderColor = UIColor.black.cgColor
            }
            else {
                contentLabel.textColor = .gray2
                layer.borderColor = UIColor.gray2.cgColor
            }
        }
    }
    
    func configureCell(with label: String) {
        layer.borderColor = UIColor.gray2.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = frame.height / 2
        
        contentLabel.font = .AppleSDGothicM(size: 13)
        contentLabel.textColor = .gray2
        contentLabel.text = "\(label)"
    }
}
