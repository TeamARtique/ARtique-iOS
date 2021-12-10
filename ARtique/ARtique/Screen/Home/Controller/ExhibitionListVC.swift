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
    
    var currentIndex:CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageTV.dataSource = self
        pageTV.delegate = self
        
        setUpTV()
    }
}

//MARK: - Custom Method
extension ExhibitionListVC{
    /// setUpTV - 테이블뷰 Setting
    func setUpTV(){
        pageTV.bounces = false
        pageTV.showsVerticalScrollIndicator = false
        pageTV.separatorColor = .clear
        
        view.backgroundColor = .black
        
        // Paging
        pageTV.decelerationRate = UIScrollView.DecelerationRate.fast
    }
}

//MARK: UITableViewDataSource
extension ExhibitionListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = pageTV.dequeueReusableCell(withIdentifier: "exhibitionListTVC", for: indexPath) as! ExhibitionListTVC
            cell.subTitle.text = "YELYN ARTI를 위한 전시"
            cell.delegate = self
            cell.cellIdentifier = 0
            return cell
        } else if indexPath.row == 1 {
            let cell = pageTV.dequeueReusableCell(withIdentifier: "exhibitionListTVC", for: indexPath) as! ExhibitionListTVC
            cell.subTitle.text = "ARTI들의 인기 전시"
            cell.delegate = self
            cell.cellIdentifier = 1
            return cell
        } else {
            let cell = pageTV.dequeueReusableCell(withIdentifier: "allTVC", for: indexPath) as! AllTVC
            cell.subTitle.text = tabmanBarItems![0].title
            cell.delegate = self
            cell.cellIdentifier = 2
            return cell
        }
    }
    
    // hide on scrolling
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
            navigationController?.setNavigationBarHidden(true, animated: true)
        } else {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
}
//MARK: UITableViewDelegate
extension ExhibitionListVC: UITableViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let cellHeight:CGFloat = 536
        var offset = targetContentOffset.pointee
        let index = (offset.y + scrollView.contentInset.top) / cellHeight
        var roundedIndex = round(index)
        
        if scrollView.contentOffset.y > targetContentOffset.pointee.y {
            roundedIndex = floor(index)
        } else if scrollView.contentOffset.y < targetContentOffset.pointee.y {
            roundedIndex = ceil(index)
        } else {
            roundedIndex = round(index)
        }
        
        if currentIndex > roundedIndex {
            currentIndex -= 1
            roundedIndex = currentIndex
        } else if currentIndex < roundedIndex {
            currentIndex += 1
            roundedIndex = currentIndex
        }
        
        if currentIndex < 3 {
            offset = CGPoint(x: scrollView.contentInset.left, y:roundedIndex * cellHeight -  scrollView.contentInset.top)
            targetContentOffset.pointee = offset
        }
    }
}

//MARK: CVCellDelegate 화면 전환용
extension ExhibitionListVC: CVCellDelegate {
    func selectedCVC(_ index: IndexPath, _ cellIdentifier: Int, _ collectionView: UICollectionView) {
        guard let detailVC = UIStoryboard(name: "Detail", bundle: nil).instantiateViewController(withIdentifier:  "Detail") as? DetailVC else {return}
        
        if cellIdentifier == 2{
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
