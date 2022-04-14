//
//  AllTVC.swift
//  ARtique
//
//  Created by 황윤경 on 2021/12/05.
//

import UIKit

class HomeVerticalTVC: UITableViewCell{
    // 임시 데이터
    let allData = [
        ExhibitionData("My Lovely Cat", "우주인", UIImage(named: "MyLovelyCat")!, 8, 6),
        ExhibitionData("Future Body", "cl0ud", UIImage(named: "Future_Body")!, 10, 2),
        ExhibitionData("The Cat", "asdf", UIImage(named: "theCat")!, 12, 10),
        ExhibitionData("AGITATO 고양이", "TATO", UIImage(named: "AGITATO")!, 5, 3),
        ExhibitionData("제주 고양이", "juJe", UIImage(named: "JejuCat")!, 20, 15),
        ExhibitionData("Cat and Flower", "caf", UIImage(named: "CatAndFlower")!, 13, 9),
        ExhibitionData("This is the Sun", "Magdiel", UIImage(named: "ThisistheSun")!, 120, 56),
        ExhibitionData("SAISON 17/18", "is0n", UIImage(named: "SAISON")!, 112, 89),
        ExhibitionData("Love Love Love", "Lx3", UIImage(named: "LoveLoveLove")!, 212, 101),
        ExhibitionData("PhotoClub", "toPho", UIImage(named: "PhotoClub")!, 95, 73),
        ExhibitionData("APOLLO", "StrongArm", UIImage(named: "APOLLO")!, 220, 115),
        ExhibitionData("우리 코코", "plataa", UIImage(named: "coco_phoster")!, 312, 198)
    ]

    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var showAllListBtn: UIButton!
    @IBOutlet weak var allExhibitionCV: UICollectionView!
    
    // TVC cell 구분용
    var cellIdentifier = 0
    
    // 화면 전환용
    var delegate: CVCellDelegate?
    
    let sectionInsets = UIEdgeInsets(top: 13.0, left: 31.5, bottom: 0.0, right: 31.5)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpDelegate()
        setUpAllTVCView()
        setlastCV()
    }
}

//MARK: - Custom Method
extension HomeVerticalTVC {
    func setUpDelegate() {
        allExhibitionCV.delegate = self
        allExhibitionCV.dataSource = self
    }
    
    func setUpAllTVCView() {
        showAllListBtn.backgroundColor = .black
        showAllListBtn.layer.cornerRadius = showAllListBtn.frame.height / 2
        
        showAllListBtn.setTitle("전체보기", for: .normal)
        showAllListBtn.titleLabel?.font = UIFont.AppleSDGothicB(size: 11)
        showAllListBtn.tintColor = .white
    }
    
    func setlastCV() {
        allExhibitionCV.isScrollEnabled = false
    }
}

// MARK: UICollectionViewDataSource
extension HomeVerticalTVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.allCVC, for: indexPath) as! AllCVC
        cell.phoster.image = allData[11 - indexPath.row * 2].phoster
        cell.title.text = allData[11 - indexPath.row * 2].title
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension HomeVerticalTVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 화면 전환
        if let delegate = delegate {
            delegate.selectedCVC(indexPath, cellIdentifier, collectionView)
        }
    }
}
// MARK: UICollectionViewDelegateFlowLayout
extension HomeVerticalTVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let itemsPerRow: CGFloat = 2
        let widthPadding = sectionInsets.left * itemsPerRow + 10

        let cellWidth = (width - widthPadding) / itemsPerRow
        let cellHeight = 4 * cellWidth / 3 + 30

        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.top
    }
}
