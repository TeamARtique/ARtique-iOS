//
//  ExhibitionListCVC.swift
//  ARtique
//
//  Created by 황윤경 on 2021/12/05.
//

import UIKit
import Kingfisher

class HomeHorizontalCVC: UICollectionViewCell {
    @IBOutlet weak var poster: UIImageView!
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
        poster.kf.setImage(with: exhibition.posterImgURL,
                            placeholder: UIImage(named: "DefaultPoster"),
                            options: [
                              .scaleFactor(UIScreen.main.scale),
                              .cacheOriginalImage
                            ])
        exhibitionData = exhibition
        title.text = exhibition.title ?? "ARtique"
        author.text = exhibition.artist?.nickname ?? "ARTI"
        likeCnt.text = exhibition.like?.likeCnt
        isLiked.image = (exhibition.like?.isLiked ?? false)
        ? UIImage(named: "Like_Selected")!
        : UIImage(named: "Like_UnSelected")!
        bookmarkCnt.text = exhibition.bookmark?.bookmarkCnt
        isBookmarked.image = (exhibition.bookmark?.isBookmarked ?? false)
        ? UIImage(named: "BookMark_Selected")!
        : UIImage(named: "BookMark_UnSelected")!
    }
}
