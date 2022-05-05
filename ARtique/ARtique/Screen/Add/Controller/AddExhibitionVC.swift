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

class AddExhibitionVC: UIViewController {
    @IBOutlet weak var progressBaseView: UIView!
    @IBOutlet weak var progressIndicator: UIView!
    @IBOutlet weak var progress: NSLayoutConstraint!
    @IBOutlet weak var contentSV: UIScrollView!
    
    let exhibitionModel = NewExhibition.shared
    let themeView = ThemeView()
    let artworkSelectView = ArtworkSelectView()
    let orderView = OrderView()
    let postExplainView = PostExplainView()
    let exhibitionExplainView = ExhibitionExplainView()
    let bag = DisposeBag()
    
    var page: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureProgressView()
        configureContentSV()
        configureStackView()
        hideKeyboard()
        setNotification()
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
        let registerProcessViews = [themeView,
                                    artworkSelectView,
                                    orderView,
                                    postExplainView,
                                    exhibitionExplainView]
        
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
    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(presentAlbumList), name: .whenAlbumListBtnSelected, object: nil)
    }
    
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
            artworkSelectView.maxArtworkCnt = exhibitionModel.artworkCnt ?? 0
            artworkSelectView.selectedImages = exhibitionModel.selectedArtwork ?? [UIImage]()
        case 2:
            orderView.selectedPhotoCV.reloadData()
            orderView.selectedPhotoCV.scrollToItem(at: [0,0], at: .top, animated: false)
        case 3:
            postExplainView.artworkListView.artworkCV.reloadData()
            postExplainView.artworkListView.artworkCV.scrollToItem(at: [0,0], at: .left, animated: false)
        case 4:
            exhibitionExplainView.baseSV.scrollToTop()
            exhibitionExplainView.phosterCV.reloadData()
        default:
            break
        }
    }
    
    /// 순서 조정 단계에서 테마 선택 단계로 돌아갈 경우 선택된 사진을 모두 지우는 함수
    private func deletePrevData(_ page: Int) {
        if page == 1 {
            NewExhibition.shared.selectedArtwork?.removeAll()
            artworkSelectView.galleryCV.indexPathsForSelectedItems?.forEach({
                artworkSelectView.galleryCV.deselectItem(at: $0, animated: false)
            })
            artworkSelectView.galleryCV.scrollToItem(at: [0,0], at: .top, animated: false)
            NotificationCenter.default.post(name: .whenAlbumChanged, object: 0)
        }
    }
    
    @objc func presentAlbumList(_ notification: Notification) {
        let albumListVC = UIStoryboard(name: Identifiers.albumListTVC, bundle: nil).instantiateViewController(withIdentifier: Identifiers.albumListTVC) as! AlbumListTVC
        albumListVC.albumList = notification.object as! [PHAssetCollection]
        
        self.present(albumListVC, animated: true, completion: nil)
    }
    
    @objc func dismissAlert() {
        dismiss(animated: false, completion: nil)
    }
    
    @objc func removeAllExhibitionData() {
        NewExhibition.shared.artworkCnt = nil
        NewExhibition.shared.themeId = nil
        dismiss(animated: false) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func registerExhibition() {
        // TODO: - 게시글 등록 완료
        dismiss(animated: false) {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - Bind Button Action
extension AddExhibitionVC {
    @objc func bindRightBarButton() {
        if page != 4 {
            page += 1
            configurePageView(page)
        } else {
            popupAlert(targetView: self,
                       alertType: .registerExhibition,
                       leftBtnAction: #selector(dismissAlert),
                       rightBtnAction: #selector(registerExhibition))
        }
    }
    
    @objc func bindLeftBarButton() {
        if page != 0 {
            deletePrevData(page)
            page -= 1
            configurePageView(page)
        } else {
            if NewExhibition.shared.artworkCnt != nil
                || NewExhibition.shared.themeId != nil {
                popupAlert(targetView: self,
                           alertType: .removeAllExhibition,
                           leftBtnAction: #selector(removeAllExhibitionData),
                           rightBtnAction: #selector(dismissAlert))
            } else {
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // TODO: ERROR 1) 해당 장수 넘을 경우 저장안되게 2) 네비바 타이틀
    private func bindCrop() {
        let rightBarButton = self.navigationItem.rightBarButtonItem!
        let button = rightBarButton.customView as! UIButton
        
        button.rx.tap
            .filter({ [weak self] _ in
                self?.page == 2
            })
            .bind(to: artworkSelectView.preview.crop)
            .disposed(by: bag)

        button.rx.tap
            .filter({ [weak self] _ in
                self?.page == 2
            })
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.orderView.selectedPhotoCV.reloadData()
            })
            .disposed(by: bag)
    }
}
