//
//  ExhibitionListVC.swift
//  ARtique
//
//  Created by 황윤경 on 2021/12/02.
//

import UIKit
import Tabman

class ExhibitionListVC: UIViewController {
    @IBOutlet weak var pageTV: UITableView!
    @IBOutlet weak var pageTVTopAnchor: NSLayoutConstraint!
    
    let exhibitionListTVCHeight = 536

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpDelegate()
        setUpTV()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureTopLayout()
    }
}

//MARK: - Custom Method
extension ExhibitionListVC{
    /// setUpTV - 테이블뷰 Setting
    func setUpTV(){
        pageTV.showsVerticalScrollIndicator = false
        pageTV.separatorColor = .clear
        pageTV.allowsSelection = false
        pageTV.backgroundColor = .white
        
        configureTopLayout()
        
        // Paging
        pageTV.decelerationRate = UIScrollView.DecelerationRate.fast
    }
    
    func setUpDelegate() {
        pageTV.dataSource = self
        pageTV.delegate = self
    }
    
    func configureTopLayout() {
        // 카테고리 바꿨을때 네비바 상태 공유
        if HomeVC.isNaviBarHidden {
            pageTVTopAnchor.constant = 56
        } else {
            pageTVTopAnchor.constant = 124
        }
    }
}

//MARK: UITableViewDataSource
extension ExhibitionListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = pageTV.dequeueReusableCell(withIdentifier: Identifiers.exhibitionListTVC, for: indexPath) as! ExhibitionListTVC
            cell.subTitle.text = "YELYN ARTI를 위한 전시"
            cell.delegate = self
            cell.cellIdentifier = 0
            return cell
        } else if indexPath.row == 1 {
            let cell = pageTV.dequeueReusableCell(withIdentifier: Identifiers.exhibitionListTVC, for: indexPath) as! ExhibitionListTVC
            cell.subTitle.text = "ARTI들의 인기 전시"
            cell.delegate = self
            cell.cellIdentifier = 1
            return cell
        } else {
            let cell = pageTV.dequeueReusableCell(withIdentifier: Identifiers.allTVC, for: indexPath) as! AllTVC
            cell.subTitle.text = "\(tabmanBarItems![0].title!) 전시"
            cell.delegate = self
            cell.cellIdentifier = 2
            return cell
        }
    }
}
//MARK: UITableViewDelegate
extension ExhibitionListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2 {
            let viewWidth = view.frame.width
            let cellHeight = viewWidth * 2 + 90
            return CGFloat(cellHeight)
        } else {
            // 가로 스크롤 전시 cell은 높이 고정
            return CGFloat(exhibitionListTVCHeight)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // NavigationBar hide on scrolling
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
            UIView.animate(withDuration: 0.4, delay: 0, options: UIView.AnimationOptions(), animations: {
                NotificationCenter.default.post(name: .whenExhibitionListTVScrolledUp, object: nil)
                self.pageTVTopAnchor.constant = 56
                self.view.layoutIfNeeded()
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.4, delay: 0, options: UIView.AnimationOptions(), animations: {
                NotificationCenter.default.post(name: .whenExhibitionListTVScrolledDown, object: nil)
                self.pageTVTopAnchor.constant = 124
                self.view.layoutIfNeeded()
            }, completion: nil)
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

//MARK: CVCellDelegate 화면 전환용
extension ExhibitionListVC: CVCellDelegate {
    func selectedCVC(_ index: IndexPath, _ cellIdentifier: Int, _ collectionView: UICollectionView) {
        guard let detailVC = UIStoryboard(name: Identifiers.detailSB, bundle: nil).instantiateViewController(withIdentifier: Identifiers.detailVC) as? DetailVC else { return }
        
        if cellIdentifier == 2 {
            let cell = collectionView.cellForItem(at: index) as! AllCVC
            
            detailVC.titleTmp = cell.title.text
            detailVC.phosterTmp = cell.phoster.image
            detailVC.authorTmp = "자까"
            detailVC.likeCntTmp = "26"
            detailVC.bookMarkCntTmp = "20"
        } else {
            let cell = collectionView.cellForItem(at: index) as! ExhibitionListCVC
            
            detailVC.titleTmp = cell.title.text
            detailVC.authorTmp = cell.author.text
            detailVC.phosterTmp = cell.phoster.image
            detailVC.likeCntTmp = cell.likeCnt.text
            detailVC.bookMarkCntTmp = cell.bookMarkCnt.text
        }
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
