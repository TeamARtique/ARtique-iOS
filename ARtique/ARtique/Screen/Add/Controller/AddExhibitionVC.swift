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
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var scrollView: UIScrollView!
    let exhibitionModel = NewExhibition.shared
    let themeView = ThemeView()
    let artworkSelectView = ArtworkSelectView()
    let orderView = OrderView()
    let postExplainView = PostExplainView()
    let exhibitionExplainView = ExhibitionExplainView()
    let bag = DisposeBag()
    
    var progress: Float = 0.2
    var page: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureRegisterProgressView()
        configureScrollView()
        configureStackView()
        hideKeyboard()
        setNotification()
        bindCrop()
    }
}

// MARK: - Configure
extension AddExhibitionVC {
    private func configureNavigationBar() {
        setNavigationTitle(0)
        navigationController?.additionalSafeAreaInsets.top = 8
        navigationController?.setRoundRightBarBtn(navigationItem: self.navigationItem,
                                                  title: "다음",
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
    
    private func configurePrevButton() {
        navigationItem.leftBarButtonItem?.image
        = (progressView.progress < 0.3)
        ? UIImage(named: "dismissBtn")
        : UIImage(named: "BackBtn")
    }
    
    private func configureNextButton() {
        let rightBarButton = self.navigationItem.rightBarButtonItem!
        let button = rightBarButton.customView as! UIButton
        
        (progressView.progress == 1)
        ? button.setTitle("등록하기", for: .normal)
        : button.setTitle("다음", for: .normal)
    }
    
    private func configureRegisterProgressView() {
        progressView.tintColor = .black
        progressView.progress = progress
    }
    
    // MARK: - Configure Content Page
    private func configureScrollView() {
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSize(width: view.frame.width * 5,
                                        height: 0)
        scrollView.isScrollEnabled = false
    }
    
    private func setScrollViewPaging(page: Int) {
        let page = page
        let width = scrollView.frame.width
        let targetX = CGFloat(page) * width
        
        var offset = scrollView.contentOffset
        offset.x = targetX
        
        scrollView.setContentOffset(offset, animated: true)
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
        scrollView.addSubview(stackView)
        
        registerProcessViews.forEach {
            configureLayout($0)
        }
    }
    
    private func configureLayout(_ view: UIView) {
        view.snp.makeConstraints {
            $0.width.equalTo(scrollView.snp.width)
            $0.height.equalTo(scrollView.snp.height)
        }
    }
}

// MARK: - Custom Methods
extension AddExhibitionVC {
    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(setSelectedViewNaviTitle), name: .whenArtworkSelected, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(presentAlbumList), name: .whenAlbumListBtnSelected, object: nil)
    }
    
    private func setNavigationTitle(_ index: Int) {
        navigationItem.title = AddProcess.allCases[index].naviTitle
    }
    
    private func configurePageView(_ progress: Float,_ page: Int) {
        progressView.setProgress(progress, animated: true)
        setNavigationTitle(page)
        configureNaviBarButton()
        setScrollViewPaging(page: page)
        reloadPage(page)
    }
    
    private func reloadPage(_ page: Int) {
        switch page {
        case 1:
            artworkSelectView.maxArtworkCnt = exhibitionModel.artworkCnt ?? 0
            artworkSelectView.selectedImages = exhibitionModel.selectedArtwork ?? [UIImage]()
        case 2:
            orderView.artworkListView.artworkCV.reloadData()
            orderView.artworkListView.artworkCV.scrollToItem(at: [0,0], at: .left, animated: true)
        case 3:
            postExplainView.artworkListView.artworkCV.reloadData()
            postExplainView.artworkListView.artworkCV.scrollToItem(at: [0,0], at: .left, animated: true)
        case 4:
            exhibitionExplainView.scrollView.scrollToTop()
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
    
    @objc func setSelectedViewNaviTitle(_ notification: Notification) {
        navigationItem.title = "사진 선택 (\(notification.object ?? 0)/\(NewExhibition.shared.artworkCnt ?? 0))"
    }
    
    @objc func presentAlbumList(_ notification: Notification) {
        let albumListVC = UIStoryboard(name: Identifiers.albumListTVC, bundle: nil).instantiateViewController(withIdentifier: Identifiers.albumListTVC) as! AlbumListTVC
        albumListVC.albumList = notification.object as! [PHAssetCollection]
        
        self.present(albumListVC, animated: true, completion: nil)
    }
}

// MARK: - Bind Button Action
extension AddExhibitionVC {
    @objc func bindRightBarButton() {
        if progressView.progress != 1 {
            progress += 0.2
            page += 1
            configurePageView(progress, page)
        } else {
            // TODO: - 게시글 등록 완료
            dismiss(animated: true)
        }
    }
    
    @objc func bindLeftBarButton() {
        if progressView.progress > 0.3 {
            deletePrevData(page)
            progress -= 0.2
            page -= 1
            configurePageView(progress, page)
        } else {
            dismiss(animated: true)
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
                self.orderView.artworkListView.artworkCV.reloadData()
            })
            .disposed(by: bag)
    }
}
