//
//  AlbumTVC.swift
//  ARtique
//
//  Created by 황윤경 on 2022/04/04.
//

import UIKit
import Photos

class AlbumTVC: UITableViewCell {
    @IBOutlet weak var thumbnailImg: UIImageView!
    @IBOutlet weak var albumTitle: UILabel!
    @IBOutlet weak var albumCnt: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureFont()
    }
    
    private func configureFont() {
        thumbnailImg.contentMode = .scaleAspectFill
        albumTitle.font = .AppleSDGothicB(size: 16)
        albumTitle.textColor = .black
        albumCnt.font = .AppleSDGothicM(size: 12)
        albumCnt.textColor = .black
    }
    
    func configureCell(with album: PHAssetCollection) {
        let assetsFetchResult: PHFetchResult = PHAsset.fetchAssets(in: album, options: nil)
        albumTitle.text = album.localizedTitle ?? ""
        albumCnt.text = "\(assetsFetchResult.count)"
        
        if assetsFetchResult.count == 0 { return }
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .exact
        PHImageManager.default().requestImage(for: assetsFetchResult.object(at: assetsFetchResult.count - 1) ,
                                                 targetSize: CGSize(width: 80,
                                                                    height: 80),
                                                 contentMode: .aspectFill,
                                                 options: options) { (image, _) in
            if image != nil {
                self.thumbnailImg.image = image
            }
        }
    }
}
