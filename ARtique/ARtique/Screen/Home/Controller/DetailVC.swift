//
//  DetailVC.swift
//  ARtique
//
//  Created by 황윤경 on 2021/11/30.
//

import UIKit

class DetailVC: UIViewController {
    @IBOutlet weak var phoster: UIImageView!
    @IBOutlet weak var exhiTitle: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var explaination: UITextView!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var likeCnt: UILabel!
    @IBOutlet weak var bookMarkBtn: UIButton!
    @IBOutlet weak var bookMarkCnt: UILabel!
    @IBOutlet weak var gotoARBtn: UIButton!
    
    var phosterTmp:UIImage?
    var titleTmp:String?
    var authorTmp:String?
    var likeCntTmp:String?
    var bookMarkCntTmp:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNaviBar()
        setView()
    }
    
    // MARK: Btn Action
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
    
    @IBAction func goToARGalleryBtnDidTap(_ sender: UIButton) {
        let galleryVC = ViewControllerFactory.viewController(for: .arGallery)
        galleryVC.modalPresentationStyle = .fullScreen
        present(galleryVC, animated: true, completion: nil)
    }
}
//MARK: - Custom Method
extension DetailVC {
    /// setNaviBar - 네비게이션바 Setting
    func setNaviBar(){
        navigationController?.navigationBar.topItem?.title=""
    }
    
    /// setView - 오브젝트 Setting
    func setView(){
        phoster.image = phosterTmp
        exhiTitle.text = titleTmp
        author.text = authorTmp
        likeCnt.text = likeCntTmp
        bookMarkCnt.text = bookMarkCntTmp
        
        // AR전시 보러가기 Btn
        gotoARBtn.backgroundColor = .black
        gotoARBtn.tintColor = .white
        gotoARBtn.setTitle("AR 전시 보러가기  →", for: .normal)
        gotoARBtn.titleLabel?.font = UIFont.AppleSDGothicB(size: 16)
        gotoARBtn.layer.cornerRadius = gotoARBtn.frame.height/2
    }
}
