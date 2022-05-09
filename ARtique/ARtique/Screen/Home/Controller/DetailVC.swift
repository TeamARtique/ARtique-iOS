//
//  DetailVC.swift
//  ARtique
//
//  Created by 황윤경 on 2021/11/30.
//

import UIKit
import SnapKit

class DetailVC: BaseVC {
    @IBOutlet weak var phoster: UIImageView!
    @IBOutlet weak var phosterOverlay: UIView!
    @IBOutlet weak var infoTopView: UIView!
    @IBOutlet weak var infoTopViewTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var infoCenterHeight: NSLayoutConstraint!
    @IBOutlet weak var exhiTitle: UILabel!
    @IBOutlet weak var author: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var bookMarkBtn: UIButton!
    @IBOutlet weak var tagStackView: UIStackView!
    @IBOutlet weak var createdAt: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var gallery: UILabel!
    @IBOutlet weak var explaination: UILabel!
    @IBOutlet weak var gotoARBtn: UIButton!
    
    var isAuthor: Bool?
    var exhibitionData: ExhibitionData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureLayout(isScrolled: false)
        configureExhibitionData()
        configureNaviBar()
        configureARBtn()
        addScrollGesture()
    }
    
    // MARK: Btn Action
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
    
    @IBAction func didTapAuthorBtn(_ sender: Any) {
        //TODO: - 작가 프로필 화면 연결
    }
}

//MARK: - Configure
extension DetailVC {
    private func configureView() {
        exhiTitle.font = .AppleSDGothicB(size: 18)
        exhiTitle.setLineBreakMode()
        phoster.contentMode = .scaleAspectFill
        explaination.font = .AppleSDGothicL(size: 14)
        explaination.setLineBreakMode()
        author.titleLabel?.font = .AppleSDGothicL(size: 13)
        author.imageView?.layer.cornerRadius = 12
        createdAt.textColor = .gray3
        category.textColor = .gray3
        gallery.textColor = .gray3
        infoTopView.layer.cornerRadius = 15
        infoTopView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private func configureNaviBar() {
        navigationController?.additionalSafeAreaInsets.top = 8
        navigationController?.navigationBar.tintColor = .black
        navigationItem.title = exhibitionData?.title
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "BackBtn"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(popVC))
        
        let share = UIAction(title: "공유",
                             image: UIImage(named: "Share")) { _ in
            self.didTapShareBtn()
        }
        let edit = UIAction(title: "수정",
                            image: UIImage(named: "Edit"),
                            handler: { _ in
            // TODO: - 전시 수정
            print("수정")
        })
        let delete = UIAction(title: "삭제",
                              image: UIImage(named: "Delete"),
                              handler: { _ in
            // TODO: - 전시 삭제
            print("삭제")
        })
        let naviRightBtn = UIBarButtonItem(image: UIImage(systemName: "ellipsis"),
                                           style: .plain,
                                           target: self,
                                           action: nil)
        naviRightBtn.menu = UIMenu(title: "",
                                   image: UIImage(systemName: "heart.fill"),
                                   identifier: nil,
                                   options: .displayInline,
                                   children: [share, edit, delete])
        
        navigationItem.rightBarButtonItem
        = isAuthor ?? false
        ? naviRightBtn
        : UIBarButtonItem(image: UIImage(named: "Share"),
                          style: .plain,
                          target: self,
                          action: #selector(didTapShareBtn))
    }
    
    private func configureLayout(isScrolled: Bool) {
        if isScrolled {
            navigationItem.title = ""
            phosterOverlay.layer.opacity = 0.3
            phoster.snp.remakeConstraints {
                $0.top.equalToSuperview()
                $0.leading.equalToSuperview()
                $0.trailing.equalToSuperview()
            }
            infoCenterHeight.constant = 125
            infoTopViewTopAnchor.constant = screenHeight - (phoster.frame.height + infoTopView.frame.height + 123 + 122 + 89)
        } else {
            navigationItem.title = exhibitionData?.title
            phosterOverlay.layer.opacity = 0
            phoster.snp.remakeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
                $0.leading.equalToSuperview().offset(20)
                $0.trailing.equalToSuperview().offset(-20)
            }
            infoCenterHeight.constant = 0
            infoTopViewTopAnchor.constant = 0
        }
    }
    
    private func configureARBtn(){
        gotoARBtn.backgroundColor = .black
        gotoARBtn.tintColor = .white
        gotoARBtn.setTitle("AR 전시 보러가기  →", for: .normal)
        gotoARBtn.titleLabel?.font = UIFont.AppleSDGothicB(size: 16)
        gotoARBtn.layer.cornerRadius = gotoARBtn.frame.height/2
    }
    
    private func configureExhibitionData() {
        isAuthor = true
        phoster.image = exhibitionData?.phoster
        exhiTitle.text = exhibitionData?.title
        author.setTitle("  " + (exhibitionData?.author ?? ""), for: .normal)
        author.setImage(UIImage(named: "Theme2")?.resized(to: CGSize(width: 24, height: 24)), for: .normal)
        likeBtn.isSelected = false
        bookMarkBtn.isSelected = false
        createdAt.text = "2021/11/19"
        category.text = CategoryType.allCases[0].categoryTitle
        gallery.text = "화이트 / 5개"
        configureTagStackView()
    }
    
    private func configureTagStackView() {
        exhibitionData?.tagId.forEach { tagId in
            let tag = UIView()
            tag.layer.cornerRadius = 10
            tag.layer.borderColor = UIColor.black.cgColor
            tag.layer.borderWidth = 0.6
            
            let tagTitle = UILabel()
            tagTitle.font = .AppleSDGothicL(size: 11)
            tagTitle.text = "\(TagType.allCases[tagId].tagTitle)"
            
            tag.addSubview(tagTitle)
            tagStackView.addArrangedSubview(tag)
            tagTitle.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(11)
                $0.trailing.equalToSuperview().offset(-11)
                $0.top.bottom.equalToSuperview()
            }
            tag.snp.makeConstraints {
                $0.height.equalToSuperview()
            }
        }
    }
}

//MARK: - Custom Method
extension DetailVC {
    private func addScrollGesture() {
        let scrollGesture = UIPanGestureRecognizer(target: self, action: #selector(viewVerticalScroll))
        view.addGestureRecognizer(scrollGesture)
    }
    
    @objc func viewVerticalScroll(sender: UIPanGestureRecognizer) {
        let dragPosition = sender.translation(in: self.view)
        let isScrolled = dragPosition.y < 0 ? true : false
        UIView.animate(withDuration: 0.3) {
            self.configureLayout(isScrolled: isScrolled)
            self.view.layoutIfNeeded()
        }
    }

    @objc func didTapShareBtn() {
        // TODO: - Firebase 연동 후 동적 URL 생성
        let url = "Exhibition URL"
        let activityVC = UIActivityViewController(activityItems: [url, phoster.image ?? UIImage()], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(activityVC, animated: true, completion: nil)
    }
}
