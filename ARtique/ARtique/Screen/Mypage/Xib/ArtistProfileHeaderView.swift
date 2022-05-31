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
    private func configureContentView() {
        let profileTapGesture = UITapGestureRecognizer(target: self, action: #selector(showProfile))
        profileImg.addGestureRecognizer(profileTapGesture)
        profileImg.isUserInteractionEnabled = true
        
        profileImg.layer.cornerRadius = profileImg.frame.height / 2
        nickname.font = .AppleSDGothicSB(size: 17)
        explanation.font = .AppleSDGothicR(size: 12)
        snsUrl.font = .AppleSDGothicR(size: 12)
    }
    
    func configureArtistData(artist: ArtistProfile) {
        configureContentView()
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
    
    @objc func showProfile() {
        let baseVC = self.findViewController() as! ArtistProfileVC
        baseVC.showProfileImage(with: profileImg.image ?? UIImage(named: "DefaultProfile")!)
    }
}
