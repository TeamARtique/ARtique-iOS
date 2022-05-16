//
//  ExhibitionCVC.swift
//  ARtique
//
//  Created by 황윤경 on 2022/04/09.
//

import UIKit
import SnapKit
import Kingfisher

class ExhibitionCVC: UICollectionViewCell {
    @IBOutlet weak var phoster: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var isLiked: UIImageView!
    @IBOutlet weak var likeCnt: UILabel!
    @IBOutlet weak var isBookmarked: UIImageView!
    @IBOutlet weak var bookmarkCnt: UILabel!
    
    var exhibitionData: ExhibitionModel?
    
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
    
    func configureCell(_ exhibition: ExhibitionModel) {
        exhibitionData = exhibition
        phoster.kf.setImage(with: exhibition.phosterImgURL,
                            placeholder: UIImage(named: "DefaultPhoster"),
                            options: [
                              .scaleFactor(UIScreen.main.scale),
                              .cacheOriginalImage
                            ])
        title.text = exhibition.title ?? "ARtique"
        author.text = exhibition.artist?.nickname ?? "ARTI"
        date.text = exhibition.date ?? "Date"
        likeCnt.text = "\(exhibition.like?.likeCount ?? 0)"
        isLiked.image = (exhibition.like?.isLiked ?? false)
        ? UIImage(named: "Like_Selected")!
        : UIImage(named: "Like_UnSelected")!
        bookmarkCnt.text = "\(exhibition.bookmark?.bookmarkCount ?? 0)"
        isBookmarked.image = (exhibition.bookmark?.isBookmarked ?? false)
        ? UIImage(named: "BookMark_Selected")!
        : UIImage(named: "BookMark_UnSelected")!
    }
}

