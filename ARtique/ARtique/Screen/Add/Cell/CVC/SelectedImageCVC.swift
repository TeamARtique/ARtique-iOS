//
//  SelectedImageCVC.swift
//  ARtique
//
//  Created by 황윤경 on 2022/03/22.
//

import UIKit

class SelectedImageCVC: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    var id: String = ""
    var isSet: Bool?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override var isSelected: Bool {
        didSet{
            if isSelected {
                layer.borderColor = UIColor.black.cgColor
            }
            else {
                layer.borderColor = UIColor.clear.cgColor
            }
        }
    }

    func configureCell(with artwork: UIImage) {
        image.image = artwork
        layer.borderColor = UIColor.clear.cgColor
        layer.borderWidth = 3
        
        isSelected = (isSet ?? false) ? true : false
    }
}
