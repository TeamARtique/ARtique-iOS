//
//  ThemeCVC.swift
//  ARtique
//
//  Created by 황윤경 on 2022/03/16.
//

import UIKit

class ThemeCVC: UICollectionViewCell {
    @IBOutlet weak var themeImage: UIImageView!
    @IBOutlet weak var selectedOverlay: UIView!
    @IBOutlet weak var themeTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override var isSelected: Bool {
        didSet{
            if isSelected {
                themeImage.layer.borderColor = UIColor.black.cgColor
                selectedOverlay.isHidden = false
            }
            else {
                themeImage.layer.borderColor = UIColor.clear.cgColor
                selectedOverlay.isHidden = true
            }
        }
    }

    func configureCell(image: UIImage, title: String) {
        themeImage.layer.borderWidth = 5
        themeImage.layer.borderColor = UIColor.clear.cgColor
        
        themeImage.image = image
        themeTitle.text = title
        
        selectedOverlay.isHidden = true
    }
}
