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
    
    let exhibitionListTVCHeight = 536

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 자동로그인
        requestRenewalToken(refreshToken: UserDefaults.standard.string(forKey: UserDefaults.Keys.refreshToken) ?? "")
        setUpDelegate()
        setUpTV()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureTopLayout()
    }
}

// MARK: - Custom Method
extension HomeListVC{
    func setUpTV(){
        pageTV.showsVerticalScrollIndicator = false
        pageTV.separatorColor = .clear
        pageTV.allowsSelection = false
        pageTV.backgroundColor = .white
        
        // Paging
        pageTV.decelerationRate = UIScrollView.DecelerationRate.fast
    }
    
    func setUpDelegate() {
        pageTV.dataSource = self
        pageTV.delegate = self
    }
    
    /// 카테고리 바꿨을때 네비바 상태 공유
    func configureTopLayout() {
        pageTVTopAnchor.constant = HomeVC.isNaviBarHidden ? 56 : 124
    }
    
    private func animateUIView(topAnchorConstant: CGFloat, NotificationName: Notification.Name) {
        UIView.animate(withDuration: 0.4, delay: 0, options: UIView.AnimationOptions(), animations: {
            NotificationCenter.default.post(name: NotificationName, object: nil)
            self.pageTVTopAnchor.constant = topAnchorConstant
            self.view.layoutIfNeeded()
        }, completion: nil)
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
            cell.subTitle.text = "YELYN ARTI를 위한 전시"
            cell.delegate = self
            cell.cellIdentifier = 0
            return cell
        } else if indexPath.row == 1 {
            let cell = pageTV.dequeueReusableCell(withIdentifier: Identifiers.homeHorizontalTVC, for: indexPath) as! HomeHorizontalTVC
            cell.subTitle.text = "ARTI들의 인기 전시"
            cell.delegate = self
            cell.cellIdentifier = 1
            return cell
        } else {
            let cell = pageTV.dequeueReusableCell(withIdentifier: Identifiers.homeVerticalTVC, for: indexPath) as! HomeVerticalTVC
            cell.subTitle.text = "\(tabmanBarItems![0].title!) 전시"
            cell.delegate = self
            cell.cellIdentifier = 2
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension HomeListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2 {
            let viewWidth = view.frame.width
            let cellHeight = viewWidth * 2 + 90
            return CGFloat(cellHeight)
        } else {
            return CGFloat(exhibitionListTVCHeight)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
            animateUIView(topAnchorConstant: 56, NotificationName: .whenExhibitionListTVScrolledUp)
        } else {
            animateUIView(topAnchorConstant: 124, NotificationName: .whenExhibitionListTVScrolledDown)
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
        
        if cellIdentifier == 2 {
            guard let cell = collectionView.cellForItem(at: index) as? AllCVC else { return }
            detailVC.exhibitionData = cell.exhibitionData
        } else {
            guard let cell = collectionView.cellForItem(at: index) as? HomeHorizontalCVC else { return }
            detailVC.exhibitionData = cell.exhibitionData
        }
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
