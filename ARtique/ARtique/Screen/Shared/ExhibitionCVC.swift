//
//  ExhibitionCVC.swift
//  ARtique
//
//  Created by 황윤경 on 2022/04/09.
//

import UIKit

class ExhibitionCVC: UICollectionViewCell {
    @IBOutlet weak var phoster: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureFont()
    }
}

extension ExhibitionCVC {
    private func configureFont() {
        title.font = .AppleSDGothicM(size: 13)
        date.font = .AppleSDGothicR(size: 11)
        
    }
    
    func configureCell(_ title: String, _ date: String) {
        self.title.text = title
        self.date.text = date
    }
}
