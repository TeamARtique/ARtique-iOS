//
//  ExhibitionListCVC.swift
//  ARtique
//
//  Created by 황윤경 on 2021/12/05.
//

import UIKit

class ExhibitionListCVC: UICollectionViewCell {
    @IBOutlet weak var phoster: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var author: UILabel!
    
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var bookMarkBtn: UIButton!
    @IBOutlet weak var likeCnt: UILabel!
    @IBOutlet weak var bookMarkCnt: UILabel!
    
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
            bookMarkCnt.text = "\(Int(bookMarkCnt.text!)! - 1)"
        } else {
            bookMarkBtn.setImage(UIImage(named: "BookMark_Selected"), for: .normal)
            bookMarkCnt.text = "\(Int(bookMarkCnt.text!)! + 1)"
        }
    }
}
