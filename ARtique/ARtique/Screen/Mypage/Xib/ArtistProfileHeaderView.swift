//
//  ArtistProfileHeaderView.swift
//  ARtique
//
//  Created by 황윤경 on 2022/05/30.
//

import UIKit
import Kingfisher

class ArtistProfileHeaderView: UICollectionReusableView {
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var explanation: UILabel!
    @IBOutlet weak var snsUrl: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Configure
extension ArtistProfileHeaderView {
    private func configureFont() {
        nickname.font = .AppleSDGothicSB(size: 17)
        explanation.font = .AppleSDGothicL(size: 12)
        snsUrl.font = .AppleSDGothicL(size: 12)
    }
    
    func configureArtistData(artist: ArtistProfile) {
        configureFont()
        profileImg.kf.setImage(with: URL(string: artist.profileImage),
                               placeholder: UIImage(named: "DefaultProfile"),
                               options: [
                                 .scaleFactor(UIScreen.main.scale),
                                 .cacheOriginalImage
                               ])
        nickname.text = artist.nickname
        explanation.text = artist.introduction
        snsUrl.text = artist.website
    }
}
