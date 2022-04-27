//
//  ExhibitionCVC.swift
//  ARtique
//
//  Created by 황윤경 on 2022/04/09.
//

import UIKit
import SnapKit

class ExhibitionCVC: UICollectionViewCell {
    @IBOutlet weak var phoster: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    
    var exhibitionData: ExhibitionData?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureFont()
    }
}

extension ExhibitionCVC {
    private func configureFont() {
        phoster.contentMode = .scaleAspectFill
        title.font = .AppleSDGothicM(size: 13)
        date.font = .AppleSDGothicR(size: 11)
    }
    
    func configureCell(_ exhibition: ExhibitionData) {
        exhibitionData = exhibition
        phoster.image = exhibition.phoster
        title.text = exhibition.title
    }
}
