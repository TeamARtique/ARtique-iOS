//
//  DetailVC.swift
//  ARtique
//
//  Created by 황윤경 on 2021/11/30.
//

import UIKit

class DetailVC: UIViewController {
    @IBOutlet weak var baseSV: UIScrollView!
    @IBOutlet weak var exhiTitle: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var phoster: UIImageView!
    @IBOutlet weak var createdAt: UILabel!
    @IBOutlet weak var explaination: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var bookMarkBtn: UIButton!
    @IBOutlet weak var gotoARBtn: UIButton!
    @IBOutlet weak var naviRightBtn: UIButton!
    
    var isAuthor: Bool?
    var phosterTmp:UIImage?
    var titleTmp:String?
    var authorTmp:String?
    var likeCntTmp:String?
    var bookMarkCntTmp:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: - 서버연결 후 연결
        isAuthor = false
        configureView()
        setView()
        configureMenuBtn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: Btn Action
    @IBAction func didTapBackBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapLikeBtn(_ sender: Any) {
        likeBtn.isSelected.toggle()
        likeBtn.toggleButtonImage(likeBtn.isSelected, UIImage(named: "Like_UnSelected")!, UIImage(named: "Like_Selected")!)
    }
    
    @IBAction func didTapBookMarkBtn(_ sender: Any) {
        bookMarkBtn.isSelected.toggle()
        bookMarkBtn.toggleButtonImage(bookMarkBtn.isSelected, UIImage(named: "BookMark_UnSelected")!, UIImage(named: "BookMark_Selected")!)
    }
    
    @IBAction func goToARGalleryBtnDidTap(_ sender: UIButton) {
        let galleryVC = ViewControllerFactory.viewController(for: .arGallery)
        galleryVC.modalPresentationStyle = .fullScreen
        present(galleryVC, animated: true, completion: nil)
    }
}

//MARK: - Configure
extension DetailVC {
    func configureView() {
        baseSV.showsVerticalScrollIndicator = false
        exhiTitle.font = .AppleSDGothicB(size: 17)
        author.font = .AppleSDGothicR(size: 14)
        phoster.contentMode = .scaleAspectFill
        createdAt.font = .AppleSDGothicM(size: 15)
        explaination.font = .AppleSDGothicR(size: 14)
        explaination.setLineBreakMode()
        likeBtn.isSelected = false
        bookMarkBtn.isSelected = false
    }
    
    func configureMenuBtn() {
        if isAuthor ?? false {
            naviRightBtn.setImage(UIImage(systemName: "ellipsis"), for: .normal)
            let share = UIAction(title: "공유",
                                 image: UIImage(named: "Share")) { _ in
                self.didTapShareBtn()
            }
            let edit = UIAction(title: "수정",
                                image: UIImage(named: "Edit"),
                                handler: { _ in print("수정") })
            let delete = UIAction(title: "삭제",
                                  image: UIImage(named: "Delete"),
                                  handler: { _ in print("삭제") })
            naviRightBtn.menu = UIMenu(title: "",
                                  image: UIImage(systemName: "heart.fill"),
                                  identifier: nil,
                                  options: .displayInline,
                                  children: [share, edit, delete])
            naviRightBtn.showsMenuAsPrimaryAction = true
        } else {
            naviRightBtn.setImage(UIImage(named: "Share"), for: .normal)
            naviRightBtn.addTarget(self, action: #selector(didTapShareBtn), for: .touchUpInside)
        }
    }
}

//MARK: - Custom Method
extension DetailVC {
    /// setView - 오브젝트 Setting
    func setView(){
        phoster.image = phosterTmp
        exhiTitle.text = titleTmp
        author.text = authorTmp
        
        // AR전시 보러가기 Btn
        gotoARBtn.backgroundColor = .black
        gotoARBtn.tintColor = .white
        gotoARBtn.setTitle("AR 전시 보러가기  →", for: .normal)
        gotoARBtn.titleLabel?.font = UIFont.AppleSDGothicB(size: 16)
        gotoARBtn.layer.cornerRadius = gotoARBtn.frame.height/2
    }
    
    @objc func didTapShareBtn() {
        // TODO: - Firebase 연동 후 동적 URL 생성
        let url = "Exhibition URL"
        let activityVC = UIActivityViewController(activityItems: [url, phoster.image ?? UIImage()], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(activityVC, animated: true, completion: nil)
    }
}
