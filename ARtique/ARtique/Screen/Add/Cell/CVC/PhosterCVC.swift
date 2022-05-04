//
//  SelectedImageCVC.swift
//  ARtique
//
//  Created by 황윤경 on 2022/03/22.
//

import UIKit

class PhosterCVC: BorderCVC {
//    @IBOutlet weak var image: UIImageView!
//    @IBOutlet weak var selectedOverlay: UIView!
    var id: String = ""
    var isSet: Bool?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
//    override var isSelected: Bool {
//        didSet{
//            if isSelected {
//                layer.borderColor = UIColor.black.cgColor
//                selectedOverlay.isHidden = false
//            }
//            else {
//                layer.borderColor = UIColor.clear.cgColor
//                selectedOverlay.isHidden = true
//            }
//        }
//    }

    func configureCell(with artwork: UIImage) {
//        image.backgroundColor = .black
//        image.image = artwork
//        layer.borderColor = UIColor.clear.cgColor
//        layer.borderWidth = 3
//        selectedOverlay.isHidden = true
        configureCell(image: artwork, borderWidth: 4)
        isSelected = (isSet ?? false) ? true : false
    }
}
