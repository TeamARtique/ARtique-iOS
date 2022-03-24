//
//  SelectedImageCVC.swift
//  ARtique
//
//  Created by 황윤경 on 2022/03/22.
//

import UIKit

class SelectedImageCVC: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureCell(with artwork: UIImage) {
        image.image = artwork
        layer.borderColor = UIColor.clear.cgColor
        layer.borderWidth = 7
    }
}
