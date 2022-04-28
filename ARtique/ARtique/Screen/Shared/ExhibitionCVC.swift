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
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var likeCnt: UILabel!
    @IBOutlet weak var bookmarkCnt: UILabel!
    
    var exhibitionData: ExhibitionData?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureFont()
    }
}

extension ExhibitionCVC {
    private func configureFont() {
        phoster.contentMode = .scaleAspectFill
        title.font = .AppleSDGothicB(size: 15)
        author.font = .AppleSDGothicSB(size: 12)
        date.font = .AppleSDGothicL(size: 12)
        date.textColor = .gray3
        likeCnt.font = .AppleSDGothicSB(size: 12)
        bookmarkCnt.font = .AppleSDGothicSB(size: 12)
    }
    
    func configureCell(_ exhibition: ExhibitionData) {
        exhibitionData = exhibition
        phoster.image = exhibition.phoster
        title.text = exhibition.title
        author.text = exhibition.author
        likeCnt.text = "\(exhibition.like)"
        bookmarkCnt.text = "\(exhibition.bookMark)"
    }
}
