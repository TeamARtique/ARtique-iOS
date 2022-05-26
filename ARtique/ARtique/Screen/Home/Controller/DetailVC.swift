//
//  DetailVC.swift
//  ARtique
//
//  Created by 황윤경 on 2021/11/30.
//

import UIKit
import SnapKit
import Kingfisher

class DetailVC: BaseVC {
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var posterOverlay: UIView!
    @IBOutlet weak var infoTopView: UIView!
    @IBOutlet weak var infoTopViewTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var infoCenterHeight: NSLayoutConstraint!
    @IBOutlet weak var exhiTitle: UILabel!
    @IBOutlet weak var author: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var likeCnt: UILabel!
    @IBOutlet weak var bookMarkBtn: UIButton!
    @IBOutlet weak var bookmarkCnt: UILabel!
    @IBOutlet weak var tagStackView: UIStackView!
    @IBOutlet weak var createdAt: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var gallery: UILabel!
    @IBOutlet weak var explanation: UILabel!
    @IBOutlet weak var gotoARBtn: UIButton!
    @IBOutlet weak var scrollBar: UIView!
    
    var exhibitionID: Int?
    var exhibitionData: DetailModel?
    var naviType: NaviType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setOptionalData()
        configureView()
        configureLayout(isScrolled: false)
        configureARBtn()
        addScrollGesture()
        addTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let exhibitionID = exhibitionID else { return }
        getExhibitionData(exhibitionID: exhibitionID)
    }
    
    // MARK: Btn Action
    @IBAction func didTapLikeBtn(_ sender: Any) {
        guard let count = Int(likeCnt.text ?? "0"), let exhibitionID = exhibitionID else { return }
        likeBtn.isSelected.toggle()
        likeCnt.text = likeBtn.isSelected ? "\(count + 1)" : "\(count - 1)"
        likeExhibition(exhibitionID: exhibitionID)
    }
    
    @IBAction func didTapBookMarkBtn(_ sender: Any) {
        guard let count = Int(bookmarkCnt.text ?? "0"), let exhibitionID = exhibitionID else { return }
        bookMarkBtn.isSelected.toggle()
        bookmarkCnt.text = bookMarkBtn.isSelected ? "\(count + 1)" : "\(count - 1)"
        bookmarkExhibition(exhibitionID: exhibitionID)
    }
    
    @IBAction func goToARGalleryBtnDidTap(_ sender: UIButton) {
        guard let galleryVC = UIStoryboard(name: Identifiers.arGallerySB, bundle: nil).instantiateViewController(withIdentifier: Identifiers.planeRecognitionVC) as? PlaneVC else { return }
        galleryVC.exhibitionId = exhibitionID
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
        poster.contentMode = .scaleAspectFill
        explanation.font = .AppleSDGothicL(size: 14)
        explanation.setLineBreakMode()
        author.titleLabel?.font = .AppleSDGothicL(size: 13)
        author.imageView?.layer.cornerRadius = 12
        [createdAt, category, gallery].forEach {
            $0?.textColor = .gray3
        }
        infoTopView.layer.cornerRadius = 15
        infoTopView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        scrollBar.layer.cornerRadius = scrollBar.frame.height
        
        likeBtn.toggleButtonImage(defaultImage: UIImage(named: "Like_UnSelected")!,
                                  selectedImage: UIImage(named: "Like_Selected")!)
        bookMarkBtn.toggleButtonImage(defaultImage: UIImage(named: "BookMark_UnSelected")!,
                                      selectedImage: UIImage(named: "BookMark_Selected")!)
    }
    
    private func configureNaviBar(navi: NaviType) {
        navigationController?.additionalSafeAreaInsets.top = 8
        navigationController?.navigationBar.tintColor = .black
        
        switch navi {
        case .push:
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "BackBtn"),
                                                               style: .plain,
                                                               target: self,
                                                               action: #selector(popVC))
        case .present:
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "dismissBtn"),
                                                               style: .plain,
                                                               target: self,
                                                               action: #selector(dismissVC))
        case .dismissToRoot:
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "dismissBtn"),
                                                               style: .plain,
                                                               target: self,
                                                               action: #selector(homeToRoot))
        }
    }
    
    private func configureNaviData() {
        navigationItem.title = exhibitionData?.exhibition.title
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
        = exhibitionData?.artist.isWriter ?? false
        ? naviRightBtn
        : UIBarButtonItem(image: UIImage(named: "Share"),
                          style: .plain,
                          target: self,
                          action: #selector(didTapShareBtn))
    }
    
    private func configureLayout(isScrolled: Bool) {
        if isScrolled {
            navigationItem.title = ""
            posterOverlay.layer.opacity = 0.3
            poster.snp.remakeConstraints {
                $0.top.equalToSuperview()
                $0.leading.equalToSuperview()
                $0.trailing.equalToSuperview()
            }
            infoCenterHeight.constant = 125
            infoTopViewTopAnchor.constant = screenHeight - (screenWidth / 3 * 4 + infoTopView.frame.height + 123 + 122 + 89)
        } else {
            navigationItem.title = exhibitionData?.exhibition.title
            posterOverlay.layer.opacity = 0
            poster.snp.remakeConstraints {
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
        poster.kf.setImage(with: exhibitionData?.exhibition.posterImgURL,
                            placeholder: UIImage(named: "DefaultPoster"),
                            options: [
                              .scaleFactor(UIScreen.main.scale),
                              .cacheOriginalImage
                            ])
        exhiTitle.text = exhibitionData?.exhibition.title
        explanation.text = exhibitionData?.exhibition.description
        author.setTitle("  " + (exhibitionData?.artist.nickname ?? ""), for: .normal)
        let processor = ResizingImageProcessor(referenceSize: CGSize(width: 24, height: 24))
        let modifier = AnyImageModifier { return $0.withRenderingMode(.alwaysOriginal) }
        author.kf.setImage(with: exhibitionData?.artist.profileImgURL,
                           for: .normal,
                           placeholder: UIImage(named: "DefaultProfile")?
                            .resized(to: CGSize(width: 24, height: 24)),
                           options: [
                            .scaleFactor(UIScreen.main.scale),
                            .processor(processor),
                            .imageModifier(modifier),
                            .cacheOriginalImage
                           ])
        likeBtn.isSelected = exhibitionData?.like.isLiked ?? false
        likeCnt.text = exhibitionData?.like.likeCnt
        bookMarkBtn.isSelected = exhibitionData?.bookmark.isBookmarked ?? false
        bookmarkCnt.text = exhibitionData?.bookmark.bookmarkCnt
        createdAt.text = exhibitionData?.exhibition.date ?? "Date"
        category.text = CategoryType.allCases[(exhibitionData?.exhibition.category ?? 0) - 1].categoryTitle
        gallery.text = "\(ThemeType.init(rawValue: exhibitionData?.exhibition.galleryTheme ?? 1)?.themeTitle ?? "테마") / \(exhibitionData?.exhibition.gallerySize ?? 0)개"
        configureTagStackView()
    }
    
    private func configureTagStackView() {
        exhibitionData?.exhibition.tag?.forEach { tagId in
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
        scrollGesture.delegate = self
        view.addGestureRecognizer(scrollGesture)
    }
    
    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapScroll))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func viewVerticalScroll(sender: UIPanGestureRecognizer) {
        let dragPosition = sender.translation(in: self.view)
        let isScrolled = dragPosition.y < 0 ? true : false
        UIView.animate(withDuration: 0.3) {
            self.configureLayout(isScrolled: isScrolled)
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func viewTapScroll(sender: UITapGestureRecognizer) {
        let isScrolled = navigationItem.title == "" ? false : true
        UIView.animate(withDuration: 0.3) {
            self.configureLayout(isScrolled: isScrolled)
            self.view.layoutIfNeeded()
        }
    }

    @objc func didTapShareBtn() {
        // TODO: - Firebase 연동 후 동적 URL 생성
        let url = "Exhibition URL"
        let activityVC = UIActivityViewController(activityItems: [url, poster.image ?? UIImage()], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(activityVC, animated: true, completion: nil)
    }
    
    private func setOptionalData() {
        if let navi = naviType {
            naviType = navi
            configureNaviBar(navi: navi)
        }
    }
}

// MARK: - Network
extension DetailVC {
    private func getExhibitionData(exhibitionID: Int) {
        ExhibitionDetailAPI.shared.getExhibitionData(exhibitionID: exhibitionID) { [weak self] networkResult in
            switch networkResult {
            case .success(let data):
                if let data = data as? DetailModel {
                    self?.exhibitionData = data
                    self?.configureNaviData()
                    self?.configureExhibitionData()
                }
            case .requestErr(let res):
                self?.getExhibitionData(exhibitionID: exhibitionID)
                if let message = res as? String {
                    print(message)
                    self?.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                }
            default:
                self?.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        }
    }
    
    private func likeExhibition(exhibitionID: Int) {
        PublicAPI.shared.requestLikeExhibition(exhibitionID: exhibitionID, completion: { [weak self] networkResult in
            switch networkResult {
            case .success(let res):
                if let data = res as? Liked {
                    self?.likeBtn.isSelected = data.isLiked ? true : false
                }
            case .requestErr(let res):
                if let message = res as? String {
                    print(message)
                    self?.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                }
            default:
                self?.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        })
    }
    
    private func bookmarkExhibition(exhibitionID: Int) {
        PublicAPI.shared.requestBookmarkExhibition(exhibitionID: exhibitionID, completion: { [weak self] networkResult in
            switch networkResult {
            case .success(let res):
                if let data = res as? Bookmarked {
                    self?.bookMarkBtn.isSelected = data.isBookmarked ? true : false
                }
            case .requestErr(let res):
                if let message = res as? String {
                    print(message)
                    self?.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                }
            default:
                self?.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        })
    }
}

extension DetailVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}
