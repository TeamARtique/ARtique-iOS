//
//  LatestSearchedCVC.swift
//  ARtique
//
//  Created by 황윤경 on 2022/04/16.
//

import UIKit

class LatestSearchedCVC: UICollectionViewCell {
    @IBOutlet weak var keyword: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configureCell(with label: String) {
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = frame.height / 2
        
        keyword.font = .AppleSDGothicL(size: 13)
        keyword.text = "\(label)"
        deleteBtn.imageView?.layer.transform = CATransform3DMakeScale(0.7, 0.7, 0.7)
    }
}
