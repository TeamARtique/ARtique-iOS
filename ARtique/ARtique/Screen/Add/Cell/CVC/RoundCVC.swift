//
//  RoundCVC.swift
//  ARtique
//
//  Created by 황윤경 on 2022/03/16.
//

import UIKit

class RoundCVC: UICollectionViewCell {
    @IBOutlet weak var contentLabel: UILabel!
    var fontSize: CGFloat?
    
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
                contentLabel.font = .AppleSDGothicSB(size: fontSize ?? 14)
                layer.borderColor = UIColor.black.cgColor
            }
            else {
                contentLabel.textColor = .gray2
                contentLabel.font = .AppleSDGothicL(size: fontSize ?? 14)
                layer.borderColor = UIColor.gray2.cgColor
            }
        }
    }
    
    func configureCell(with label: String, fontSize: CGFloat) {
        layer.borderColor = UIColor.gray2.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = frame.height / 2
        
        contentLabel.font = .AppleSDGothicL(size: fontSize)
        self.fontSize = fontSize
        contentLabel.textColor = .gray2
        contentLabel.text = "\(label)"
    }
}
