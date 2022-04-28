//
//  ExhibitionListCVC.swift
//  ARtique
//
//  Created by 황윤경 on 2021/12/05.
//

import UIKit

class HomeHorizontalCVC: UICollectionViewCell {
    @IBOutlet weak var phoster: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var author: UILabel!
    
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var bookMarkBtn: UIButton!
    @IBOutlet weak var likeCnt: UILabel!
    @IBOutlet weak var bookmarkCnt: UILabel!
    
    var exhibitionData: ExhibitionData?
    
    @IBAction func pushLike(_ sender: Any) {
        if likeBtn.currentImage == UIImage(named: "Like_Selected"){
            likeBtn.setImage(UIImage(named: "Like_UnSelected"), for: .normal)
            likeCnt.text = "\(Int(likeCnt.text!)! - 1)"
        } else {
            likeBtn.setImage(UIImage(named: "Like_Selected"), for: .normal)
            likeCnt.text = "\(Int(likeCnt.text!)! + 1)"
        }
    }
    @IBAction func pushBookMark(_ sender: Any) {
        if bookMarkBtn.currentImage == UIImage(named: "BookMark_Selected"){
            bookMarkBtn.setImage(UIImage(named: "BookMark_UnSelected"), for: .normal)
            bookmarkCnt.text = "\(Int(bookmarkCnt.text!)! - 1)"
        } else {
            bookMarkBtn.setImage(UIImage(named: "BookMark_Selected"), for: .normal)
            bookmarkCnt.text = "\(Int(bookmarkCnt.text!)! + 1)"
        }
    }
}

extension HomeHorizontalCVC {
    func configureCell(_ exhibition: ExhibitionData) {
        exhibitionData = exhibition
        phoster.image = exhibition.phoster
        title.text = exhibition.title
        author.text = exhibition.author
        likeCnt.text = "\(exhibition.like)"
        bookmarkCnt.text = "\(exhibition.bookMark)"
    }
}
