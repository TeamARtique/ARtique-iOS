//
//  ExhibitionListVC.swift
//  ARtique
//
//  Created by 황윤경 on 2021/12/02.
//

import UIKit
import Tabman

class HomeListVC: BaseVC {
    @IBOutlet weak var pageTV: UITableView!
    @IBOutlet weak var pageTVTopAnchor: NSLayoutConstraint!
    var categoryType: CategoryType?
    var homeListData: HomeModel?
    let refreshControl = UIRefreshControl()
    
    let exhibitionListTVCHeight = 490
    let categoryBarHeight: CGFloat = 48
    let largeNavigationBarHeight: CGFloat = 116
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 자동로그인
        requestRenewalToken(refreshToken: UserDefaults.standard.string(forKey: UserDefaults.Keys.refreshToken) ?? "")
        setUpTV()
        setNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getExhibitionList(categoryID: categoryType?.categoryId ?? 1)
        configureTopLayout()
    }
}

// MARK: - Custom Method
extension HomeListVC{
    private func setUpTV(){
        pageTV.dataSource = self
        pageTV.delegate = self
        pageTV.showsVerticalScrollIndicator = false
        pageTV.separatorColor = .clear
        pageTV.allowsSelection = false
        pageTV.backgroundColor = .white
        
        // Paging
        pageTV.decelerationRate = UIScrollView.DecelerationRate.fast
    }
    
    private func bindRefreshController() {
        refreshControl.addTarget(self, action: #selector(updateTV(refreshControl:)), for: .valueChanged)
        pageTV.refreshControl = refreshControl
    }
    
    @objc func updateTV(refreshControl: UIRefreshControl) {
        self.getExhibitionList(categoryID: categoryType?.categoryId ?? 1)
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            self.pageTV.reloadData()
            refreshControl.endRefreshing()
        }
    }
    
    /// 카테고리 바꿨을때 네비바 상태 공유
    private func configureTopLayout() {
        pageTVTopAnchor.constant = HomeVC.isNaviBarHidden ? categoryBarHeight : largeNavigationBarHeight
    }
    
    private func animateUIView(topAnchorConstant: CGFloat, NotificationName: Notification.Name) {
        UIView.animate(withDuration: 0.4, delay: 0, options: UIView.AnimationOptions(), animations: {
            NotificationCenter.default.post(name: NotificationName, object: nil)
            self.pageTVTopAnchor.constant = topAnchorConstant
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(showAllExhibitionList), name: .whenAllExhibitionBtnSelected, object: nil)
    }
    
    @objc func showAllExhibitionList(_ notification: Notification) {
        guard let exhibitionListVC = ViewControllerFactory.viewController(for: .exhibitionList) as? ExhibitionListVC else { return }
        exhibitionListVC.categoryID = categoryType?.categoryId ?? 1
        exhibitionListVC.hidesBottomBarWhenPushed = true
        exhibitionListVC.setNaviBarTitle(notification.object as? String ?? "")
        exhibitionListVC.isRightBarBtnExist = true
        navigationController?.pushViewController(exhibitionListVC, animated: true)
    }
}

// MARK: - Network
extension HomeListVC {
    private func getExhibitionList(categoryID: Int) {
        HomeAPI.shared.getHomeExhibitionList(categoryID: categoryID) { [weak self] networkResult in
            switch networkResult {
            case .success(let list):
                if let list = list as? HomeModel {
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.homeListData = list
                        self.reloadWithoutScroll(tableView: self.pageTV)
                        self.bindRefreshController()
                    }
                }
            case .requestErr(let res):
                self?.getExhibitionList(categoryID: categoryID)
                if let message = res as? String {
                    print(message)
                    self?.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                }
            default:
                self?.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        }
    }
}

// MARK: UITableViewDataSource
extension HomeListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = pageTV.dequeueReusableCell(withIdentifier: Identifiers.homeHorizontalTVC, for: indexPath) as! HomeHorizontalTVC
            cell.exhibitionData = homeListData
            cell.subTitle.text = "\(UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) ?? "") ARTI를 위한 전시"
            cell.delegate = self
            cell.cellIdentifier = 0
            cell.exhibitionListCV.reloadData()
            return cell
        } else if indexPath.row == 1 {
            let cell = pageTV.dequeueReusableCell(withIdentifier: Identifiers.homeHorizontalTVC, for: indexPath) as! HomeHorizontalTVC
            cell.exhibitionData = homeListData
            cell.subTitle.text = "ARTI들의 인기 전시"
            cell.delegate = self
            cell.cellIdentifier = 1
            cell.exhibitionListCV.reloadData()
            return cell
        } else {
            let cell = pageTV.dequeueReusableCell(withIdentifier: Identifiers.homeVerticalTVC, for: indexPath) as! HomeVerticalTVC
            cell.allData = homeListData?.categoryExhibition
            cell.subTitle.text = "\(tabmanBarItems![0].title!) 전시"
            cell.delegate = self
            cell.cellIdentifier = 2
            cell.allExhibitionCV.reloadData()
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension HomeListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2 {
            let cellWidth = (screenWidth - 55) / 2
            let cellHeight = 4 * cellWidth / 3 + 64 + 27
            
            return CGFloat(cellHeight * 3 + 82)
        } else {
            return CGFloat(exhibitionListTVCHeight)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
            animateUIView(topAnchorConstant: categoryBarHeight, NotificationName: .whenExhibitionListTVScrolledUp)
        } else {
            animateUIView(topAnchorConstant: largeNavigationBarHeight, NotificationName: .whenExhibitionListTVScrolledDown)
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        // tableview paging
        let cellHeight = CGFloat(exhibitionListTVCHeight)
        var offset = targetContentOffset.pointee
        let index = (offset.y + scrollView.contentInset.top) / cellHeight
        var roundedIndex = round(index)
        
        if scrollView.contentOffset.y > targetContentOffset.pointee.y {
            roundedIndex = floor(index)
        } else if scrollView.contentOffset.y < targetContentOffset.pointee.y {
            roundedIndex = ceil(index)
        }
        
        if index <= 2 {
            offset = CGPoint(x: scrollView.contentInset.left, y: roundedIndex * cellHeight -  scrollView.contentInset.top)
            targetContentOffset.pointee = offset
            pageTV.bounces = true
        } else {
            pageTV.bounces = false
        }
    }
}

// MARK: CVCellDelegate 화면 전환용
extension HomeListVC: CVCellDelegate {
    func selectedCVC(_ index: IndexPath, _ cellIdentifier: Int, _ collectionView: UICollectionView) {
        guard let detailVC = UIStoryboard(name: Identifiers.detailSB, bundle: nil).instantiateViewController(withIdentifier: Identifiers.detailVC) as? DetailVC else { return }
        detailVC.naviType = .push
        
        if cellIdentifier == 2 {
            guard let cell = collectionView.cellForItem(at: index) as? ExhibitionCVC else { return }
            detailVC.exhibitionID = cell.exhibitionData?.exhibitionId
        } else {
            guard let cell = collectionView.cellForItem(at: index) as? HomeHorizontalCVC else { return }
            detailVC.exhibitionID = cell.exhibitionData?.exhibitionId
        }
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
