//
//  ExhibitionListTVC.swift
//  ARtique
//
//  Created by 황윤경 on 2021/12/05.
//

import UIKit

class HomeHorizontalTVC: UITableViewCell {
    // 임시 데이터
    let forARTI_DATA = [
        ExhibitionData("My Lovely Cat", "우주인", UIImage(named: "MyLovelyCat")!, 8, 6),
        ExhibitionData("The Cat", "asdf", UIImage(named: "theCat")!, 12, 10),
        ExhibitionData("AGITATO 고양이", "TATO", UIImage(named: "AGITATO")!, 5, 3),
        ExhibitionData("제주 고양이", "juJe", UIImage(named: "JejuCat")!, 20, 15),
        ExhibitionData("Cat and Flower", "caf", UIImage(named: "CatAndFlower")!, 13, 9),
        ExhibitionData("Future Body", "cl0ud", UIImage(named: "Future_Body")!, 10, 2)
    ]
    let popular_DATA = [
        ExhibitionData("This is the Sun", "Magdiel", UIImage(named: "ThisistheSun")!, 120, 56),
        ExhibitionData("Love Love Love", "Lx3", UIImage(named: "LoveLoveLove")!, 212, 101),
        ExhibitionData("SAISON 17/18", "is0n", UIImage(named: "SAISON")!, 112, 89),
        ExhibitionData("PhotoClub", "toPho", UIImage(named: "PhotoClub")!, 95, 73),
        ExhibitionData("APOLLO", "StrongArm", UIImage(named: "APOLLO")!, 220, 115),
        ExhibitionData("우리 코코", "plataa", UIImage(named: "coco_phoster")!, 312, 198)
    ]
    
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var exhibitionListCV: UICollectionView!
    
    let cellSize = CGSize(width: 261, height: 474)
    var minItemSpacing: CGFloat = 5
    var currentIndexPath = IndexPath()
    var currentIndex:CGFloat = 0
    
    // TVC cell 구분용
    var cellIdentifier = 0
    
    // 화면 전환용
    var delegate: CVCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        exhibitionListCV.delegate = self
        exhibitionListCV.dataSource = self
        
        setUpCV()
    }
}

//MARK: - Custom Method
extension HomeHorizontalTVC {
    
    /// setUpCV - 추천(ㅇㅇARTI를 위한 전시, ARTI들의 인기 전시) collectionview Setting
    func setUpCV(){
        exhibitionListCV.showsHorizontalScrollIndicator = false
        exhibitionListCV.contentInset = UIEdgeInsets(top: 0.0, left: 29.0, bottom: 0.0, right: 29.0)
        
        if let layout = exhibitionListCV.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = minItemSpacing
        }
        exhibitionListCV.decelerationRate = UIScrollView.DecelerationRate.fast
    }
    
    /// animateZoomforCell - 현재 보이는 셀을 기존의 크기로
    func animateZoomforCell(zoomCell: UICollectionViewCell) {
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                zoomCell.transform = .identity
            },
            completion: nil)
    }
    
    /// animateZoomforCellremove - 현재 포커싱된 셀 외에는 x0.9 사이즈로
    func animateZoomforCellremove(zoomCell: UICollectionViewCell) {
        UIView.animate(
            withDuration: 0.0,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                zoomCell.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            },
            completion: nil)
    }
}

// MARK: 화면 전환 프로토콜
protocol CVCellDelegate {
    func selectedCVC(_ index: IndexPath, _ cellIdentifier: Int, _ collectionView: UICollectionView)
}

// MARK: DataSource - 임시 데이터 셋업, 서버 생성 후 수정
extension HomeHorizontalTVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 6개 고정
        return forARTI_DATA.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIndex = indexPath.row % forARTI_DATA.count
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.homeHorizontalCVC, for: indexPath) as! HomeHorizontalCVC
        
        if cellIdentifier == 0 {
            cell.phoster.image = forARTI_DATA[cellIndex].phoster
            cell.title.text = forARTI_DATA[cellIndex].title
            cell.author.text = forARTI_DATA[cellIndex].author
            cell.likeCnt.text = "\(forARTI_DATA[cellIndex].like)"
            cell.bookMarkCnt.text = "\(forARTI_DATA[cellIndex].bookMark)"
        } else {
            cell.phoster.image = popular_DATA[cellIndex].phoster
            cell.title.text = popular_DATA[cellIndex].title
            cell.author.text = popular_DATA[cellIndex].author
            cell.likeCnt.text = "\(popular_DATA[cellIndex].like)"
            cell.bookMarkCnt.text = "\(popular_DATA[cellIndex].bookMark)"
        }
        
        /// 처음 로드될 때 현재 셀 아니면 사이즈 줄이기  -> scrollViewDidScroll이랑 중복, 수정 요망
        if indexPath.row != 0 {
            animateZoomforCellremove(zoomCell: cell)
        }
        return cell
    }
}
// MARK: UICollectionViewDelegate
extension HomeHorizontalTVC: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 옆 셀 눌렀을땐 넘어가게
        if indexPath != currentIndexPath {
            exhibitionListCV.scrollToItem(at: indexPath, at: .left, animated: true)
            currentIndexPath = indexPath
        } else if let delegate = delegate {
            // 화면 전환
            delegate.selectedCVC(indexPath, cellIdentifier, collectionView)
        }
    }
    
    // CollectionView Paging
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let cellWidthIncludeSpacing = cellSize.width + minItemSpacing
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludeSpacing
        var roundedIndex = round(index)
    
        if scrollView.contentOffset.x > targetContentOffset.pointee.x {
            roundedIndex = floor(index)
        } else if scrollView.contentOffset.x < targetContentOffset.pointee.x {
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
        currentIndexPath = IndexPath(item: Int(currentIndex), section: 0)
        
        offset = CGPoint(x: roundedIndex * cellWidthIncludeSpacing - scrollView.contentInset.left, y: scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }

    // CollectionView Carousel(Focusing Animation)
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let cellWidthIncludeSpacing = cellSize.width + minItemSpacing
        let offsetX = exhibitionListCV.contentOffset.x
        let index = (offsetX + exhibitionListCV.contentInset.left) / cellWidthIncludeSpacing
        let roundedIndex = round(index)
        let indexPath = IndexPath(item: Int(roundedIndex), section: 0)

        // 현재 셀 확대(기본)
        if let cell = exhibitionListCV.cellForItem(at: indexPath) {
            animateZoomforCell(zoomCell: cell)
        }
        // 이전 셀 축소
        if let prevCell = exhibitionListCV.cellForItem(at: [0,indexPath.row - 1]) {
            animateZoomforCellremove(zoomCell: prevCell)
        }
        // 다음 셀 축소
        if let nextCell = exhibitionListCV.cellForItem(at: [0,indexPath.row + 1]){
            animateZoomforCellremove(zoomCell: nextCell)
        }
    }
}
// MARK: UICollectionViewDelegateFlowLayout
extension HomeHorizontalTVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
}

