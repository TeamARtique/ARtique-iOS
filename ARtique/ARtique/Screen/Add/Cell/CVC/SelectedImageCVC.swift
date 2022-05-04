//
//  GalleryCVC.swift
//  ARtique
//
//  Created by 황윤경 on 2022/03/22.
//

import UIKit

class GalleryCVC: BorderCVC {
    var id: String = ""
    var isSet: Bool?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    func configureCell(with artwork: UIImage) {
        configureCell(image: artwork, borderWidth: 3)
        isSelected = (isSet ?? false) ? true : false
    }
}
