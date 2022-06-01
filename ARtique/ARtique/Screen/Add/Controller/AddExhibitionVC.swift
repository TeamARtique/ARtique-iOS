//
//  AddExhibitionVC.swift
//  ARtique
//
//  Created by 황윤경 on 2022/03/15.
//

import UIKit
import SnapKit
import Photos
import RxSwift
import RxCocoa

class AddExhibitionVC: BaseVC {
    @IBOutlet weak var progressBaseView: UIView!
    @IBOutlet weak var progressIndicator: UIView!
    @IBOutlet weak var progress: NSLayoutConstraint!
    @IBOutlet weak var contentSV: UIScrollView!
  
    let exhibitionModel = NewExhibition.shared
    let themeView = UIStoryboard(name: ThemeVC.className, bundle: nil).instantiateViewController(withIdentifier: ThemeVC.className) as! ThemeVC
    let artworkSelectView = UIStoryboard(name: ArtworkSelectVC.className, bundle: nil).instantiateViewController(withIdentifier: ArtworkSelectVC.className) as! ArtworkSelectVC
    let orderView = UIStoryboard(name: OrderVC.className, bundle: nil).instantiateViewController(withIdentifier: OrderVC.className) as! OrderVC
    let postExplainView = UIStoryboard(name: PostExplainVC.className, bundle: nil).instantiateViewController(withIdentifier: PostExplainVC.className) as! PostExplainVC
    let exhibitionExplainView = UIStoryboard(name: ExhibitionExplainVC.className, bundle: nil).instantiateViewController(withIdentifier: ExhibitionExplainVC.className) as! ExhibitionExplainVC
    let bag = DisposeBag()
    let postArtworkGroup = DispatchGroup()
    
    var page: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureProgressView()
        configureContentSV()
        configureStackView()
        hideKeyboard()
    }
}

// MARK: - Configure
extension AddExhibitionVC {
    private func configureNavigationBar() {
        navigationItem.title = "전시 등록"
        navigationController?.additionalSafeAreaInsets.top = 8
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "NextBtn"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(bindRightBarButton))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "dismissBtn"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(bindLeftBarButton))
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func configureNaviBarButton() {
        configurePrevButton()
        configureNextButton()
    }
    
    private func configureProgressView() {
        progressBaseView.backgroundColor = .gray1
        progressBaseView.layer.cornerRadius = progressBaseView.frame.height / 2
        
        progressIndicator.backgroundColor = .black
        progressIndicator.layer.cornerRadius = progressIndicator.frame.height / 2
        progressIndicator.snp.makeConstraints {
            $0.width.equalToSuperview().dividedBy(5)
        }
    }
    
    private func configurePrevButton() {
        navigationItem.leftBarButtonItem?.image
        = (page == 0)
        ? UIImage(named: "dismissBtn")
        : UIImage(named: "BackBtn")
    }
    
    private func configureNextButton() {
        navigationItem.rightBarButtonItem
        = (page == 4)
        ? navigationController?.roundFilledBarBtn(title: "등록하기",
                                                  target: self,
                                                  action: #selector(bindRightBarButton))
        : UIBarButtonItem(image: UIImage(named: "NextBtn"),
                          style: .plain,
                          target: self,
                          action: #selector(bindRightBarButton))
    }
    
    // MARK: - Configure Content Page
    private func configureContentSV() {
        contentSV.showsHorizontalScrollIndicator = false
        contentSV.contentSize = CGSize(width: view.frame.width * 5,
                                        height: 0)
        contentSV.isScrollEnabled = false
    }
    
    private func setScrollViewPaging(_ page: Int) {
        let width = contentSV.frame.width
        let targetX = CGFloat(page) * width
        
        var offset = contentSV.contentOffset
        offset.x = targetX
        
        contentSV.setContentOffset(offset, animated: true)
    }
    
    private func configureStackView() {
        orderView.delegate = artworkSelectView
        
        let registerProcessViews = [themeView.view!,
                                    artworkSelectView.view!,
                                    orderView.view!,
                                    postExplainView.view!,
                                    exhibitionExplainView.view!]
        
        let stackView = UIStackView(arrangedSubviews: registerProcessViews)
        
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentSV.addSubview(stackView)
        
        registerProcessViews.forEach {
            configureLayout($0)
        }
    }
    
    private func configureLayout(_ view: UIView) {
        view.snp.makeConstraints {
            $0.width.equalTo(contentSV.snp.width)
            $0.height.equalTo(contentSV.snp.height)
        }
    }
}

// MARK: - Custom Methods
extension AddExhibitionVC {
    private func setProgress(_ page: Int) {
        UIView.animate(withDuration: 0.3) {
            self.progress.constant = CGFloat(page) * self.progressIndicator.frame.width
            self.view.layoutIfNeeded()
        }
    }
    
    private func configurePageView(_ page: Int) {
        setProgress(page)
        configureNaviBarButton()
        setScrollViewPaging(page)
        reloadPage(page)
    }
    
    private func reloadPage(_ page: Int) {
        switch page {
        case 1:
            artworkSelectView.reloadContentView()
            artworkSelectView.configureViewTitle()
            let index
            = artworkSelectView.selectedImages.count != 0
            ? artworkSelectView.indexArr[artworkSelectView.selectedImages.count - 1]
            : 0
            artworkSelectView.setPreviewImage([0, index])
        case 2:
            orderView.selectedPhotoCV.reloadData()
            orderView.selectedPhotoCV.scrollToItem(at: [0,0], at: .top, animated: false)
        case 3:
            postExplainView.artworkExplainCV.reloadData()
            postExplainView.artworkExplainCV.scrollToItem(at: [0,0], at: .left, animated: false)
        case 4:
            exhibitionExplainView.baseSV.scrollToTop()
            exhibitionExplainView.posterCV.reloadData()
            exhibitionExplainView.posterCV.scrollToItem(at: [0,0], at: .left, animated: false)
        default:
            break
        }
    }
    
    @objc func dismissAlert() {
        dismiss(animated: false, completion: nil)
    }
    
    @objc func registerCancel() {
        removeAllExhibitionData()
        dismiss(animated: false) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    /// 순서 조정 단계에서 테마 선택 단계로 돌아갈 경우 선택된 사진을 모두 지우는 함수
    @objc func removeAllPhotos() {
        artworkSelectView.selectedImages.removeAll()
        artworkSelectView.indexArr.removeAll()
        artworkSelectView.galleryCV.indexPathsForSelectedItems?.forEach({
            artworkSelectView.galleryCV.deselectItem(at: $0, animated: false)
        })
        artworkSelectView.galleryCV.scrollToItem(at: [0,0], at: .top, animated: false)
        NotificationCenter.default.post(name: .whenAlbumChanged, object: 0)
        dismiss(animated: false) {
            self.page -= 1
            self.configurePageView(self.page)
        }
    }
    
    @objc func registerExhibition() {
        LoadingIndicator.showLoading()
        self.dismiss(animated: false)
        postExhibition(exhibitionData: NewExhibition.shared)
    }
    
    private func makePoster() -> UIImage {
        let posterView = UIView()
        view.insertSubview(posterView, at: 0)
        
        let posterBase = exhibitionExplainView.posterBase ?? exhibitionModel.artworks?.first?.image
        let posterImage = PosterTheme()
        posterImage.translatesAutoresizingMaskIntoConstraints = false
        posterImage.configurePoster(themeId: PosterType.allCases[exhibitionModel.posterTheme ?? 0],
                                    poster: posterBase ?? UIImage(named: "DefaultPoster")!,
                                    title: exhibitionModel.title ?? "",
                                    nickname: UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) ?? "ARTI",
                                    date: Date().toString())
        posterView.insertSubview(posterImage.contentView, at: 0)
        exhibitionModel.posterImage = posterImage.contentView.transfromToImage() ?? UIImage(named: "DefaultPoster")!
        posterView.removeFromSuperview()
        
        return exhibitionModel.posterImage ?? UIImage()
    }
    
    private func showDetail(with exhibitionId: Int) {
        guard let detailVC = UIStoryboard(name: Identifiers.detailSB, bundle: nil).instantiateViewController(withIdentifier: Identifiers.detailVC) as? DetailVC else { return }
        
        detailVC.exhibitionID = exhibitionId
        detailVC.naviType = .dismissToRoot
        let navi = UINavigationController(rootViewController: detailVC)
        navi.modalPresentationStyle = .fullScreen
        self.present(navi, animated: true)
    }
    
    private func removeAllExhibitionData() {
        NewExhibition.shared.title = nil
        NewExhibition.shared.category = nil
        NewExhibition.shared.artworks = nil
        NewExhibition.shared.gallerySize = nil
        NewExhibition.shared.galleryTheme = nil
        NewExhibition.shared.posterImage = nil
        NewExhibition.shared.posterTheme = nil
        NewExhibition.shared.tag = nil
        NewExhibition.shared.description = nil
    }
}

// MARK: - Network
extension AddExhibitionVC {
    private func postExhibition(exhibitionData: NewExhibition) {
        RegisterAPI.shared.postExhibitionData(exhibitionData: exhibitionData) {[weak self] networkResult in
            guard let self = self else { return }
            switch networkResult {
            case .success(let data):
                if let data = data as? RegisterModel {
                    exhibitionData.artworks?.forEach({ artworkData in
                        self.postArtworkGroup.enter()
                        self.postArtworks(exhibitionId: data.exhibition.exhibitionId ?? 0,
                                          artwork: artworkData)
                    })
                    
                    self.postArtworkGroup.notify(queue: .main) {
                        self.getRegisterStatus(exhibitionID: data.exhibition.exhibitionId ?? 0)
                    }
                }
            case .requestErr(let res):
                if let message = res as? String {
                    print(message)
                    self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                }
            default:
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        }
    }
    
    private func postArtworks(exhibitionId: Int, artwork: ArtworkData) {
        RegisterAPI.shared.postArtworkData(exhibitionID: exhibitionId, artwork: artwork) {[weak self] networkResult in
            guard let self = self else { return }
            switch networkResult {
            case .success(let exhibitionData):
                if exhibitionData is ArtworkModel {
                    self.postArtworkGroup.leave()
                }
            case .requestErr(let res):
                if let message = res as? String {
                    print(message)
                    self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                }
            default:
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        }
    }
    
    private func getRegisterStatus(exhibitionID: Int) {
        RegisterAPI.shared.getRegisterStatus(exhibitionID: exhibitionID) { [weak self] networkResult in
            guard let self = self else { return }
            switch networkResult {
            case .success(_):
                self.removeAllExhibitionData()
                self.showDetail(with: exhibitionID)
                LoadingIndicator.hideLoading()
            case .requestErr(let res):
                if let message = res as? String {
                    print(message)
                    self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                }
            default:
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        }
    }
}

// MARK: - Bind Button Action
extension AddExhibitionVC {
    @objc func bindRightBarButton() {
        view.endEditing(true)
        switch page {
        case 0:
            if exhibitionModel.gallerySize != nil
                && exhibitionModel.galleryTheme != nil {
                page += 1
                configurePageView(page)
            } else {
                popupToast(toastType: .chooseAll)
            }
        case 1:
            if artworkSelectView.selectedImages.count == exhibitionModel.gallerySize {
                page += 1
                configurePageView(page)
                for i in 0..<artworkSelectView.selectedImages.count {
                    let tmp = ArtworkData()
                    tmp.image = artworkSelectView.selectedImages[i]
                    tmp.index = i + 1
                    exhibitionModel.artworks?[i] = tmp
                }
            } else {
                popupToast(toastType: .chooseAll)
            }
        case 4:
            if exhibitionModel.title != ""
                && exhibitionModel.category != nil
                && exhibitionModel.posterTheme != nil
                && exhibitionModel.description != exhibitionExplainView.exhibitionExplainPlaceholder
                && exhibitionModel.tag != nil {
                popupAlert(targetView: self,
                           alertType: .registerExhibition,
                           image: makePoster(),
                           leftBtnAction: #selector(dismissAlert),
                           rightBtnAction: #selector(registerExhibition))
            } else {
                popupToast(toastType: .chooseAll)
            }
        default:
            page += 1
            configurePageView(page)
        }
    }
    
    @objc func bindLeftBarButton() {
        view.endEditing(true)
        switch page {
        case 0:
            if exhibitionModel.gallerySize != nil
                || exhibitionModel.galleryTheme != nil {
                popupAlert(targetView: self,
                           alertType: .removeAllExhibition,
                           image: nil,
                           leftBtnAction: #selector(registerCancel),
                           rightBtnAction: #selector(dismissAlert))
            } else {
                dismiss(animated: true, completion: nil)
            }
        case 1:
            if !artworkSelectView.selectedImages.isEmpty {
                popupAlert(targetView: self,
                           alertType: .removeAllPhotos,
                           image: nil,
                           leftBtnAction: #selector(removeAllPhotos),
                           rightBtnAction: #selector(dismissAlert))
            } else {
                page -= 1
                configurePageView(page)
            }
        default:
            page -= 1
            configurePageView(page)
        }
    }
}
