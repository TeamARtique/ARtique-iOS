//
//  ExhibitionListCVC.swift
//  ARtique
//
//  Created by 황윤경 on 2021/12/05.
//

import UIKit
import Kingfisher

class HomeHorizontalCVC: UICollectionViewCell {
    @IBOutlet weak var phoster: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var isLiked: UIImageView!
    @IBOutlet weak var likeCnt: UILabel!
    @IBOutlet weak var isBookmarked: UIImageView!
    @IBOutlet weak var bookmarkCnt: UILabel!
    
    var exhibitionData: ExhibitionModel?
}

extension HomeHorizontalCVC {
    func configureCell(_ exhibition: ExhibitionModel) {
        phoster.kf.setImage(with: exhibition.phosterImgURL,
                            placeholder: UIImage(named: "DefaultPhoster"),
                            options: [
                              .scaleFactor(UIScreen.main.scale),
                              .cacheOriginalImage
                            ])
        exhibitionData = exhibition
        title.text = exhibition.title ?? "ARtique"
        author.text = exhibition.artist?.nickname ?? "ARTI"
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
