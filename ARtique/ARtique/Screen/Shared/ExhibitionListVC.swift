//
//  ExhibitionListVC.swift
//  ARtique
//
//  Created by 황윤경 on 2022/04/14.
//

import UIKit

class ExhibitionListVC: BaseVC {
    @IBOutlet weak var exhibitionListCV: UICollectionView!
    
    var exhibitionData: [ExhibitionData] = [
        ExhibitionData("My Lovely Cat", "우주인", UIImage(named: "MyLovelyCat")!, [1, 2, 3], 8, 6),
        ExhibitionData("Future Body", "cl0ud", UIImage(named: "Future_Body")!, [1, 2, 3], 10, 2),
        ExhibitionData("The Cat", "asdf", UIImage(named: "theCat")!, [1, 2, 3], 12, 10),
        ExhibitionData("AGITATO 고양이", "TATO", UIImage(named: "AGITATO")!, [1, 2, 3], 5, 3),
        ExhibitionData("제주 고양이", "juJe", UIImage(named: "JejuCat")!, [1, 2, 3], 20, 15),
        ExhibitionData("Cat and Flower", "caf", UIImage(named: "CatAndFlower")!, [1, 2, 3], 13, 9),
        ExhibitionData("This is the Sun", "Magdiel", UIImage(named: "ThisistheSun")!, [1, 2, 3], 120, 56),
        ExhibitionData("SAISON 17/18", "is0n", UIImage(named: "SAISON")!, [1, 2, 3], 112, 89),
        ExhibitionData("Love Love Love", "Lx3", UIImage(named: "LoveLoveLove")!, [1, 2, 3], 212, 101),
        ExhibitionData("PhotoClub", "toPho", UIImage(named: "PhotoClub")!, [1, 2, 3], 95, 73),
        ExhibitionData("APOLLO", "StrongArm", UIImage(named: "APOLLO")!, [1, 2, 3], 220, 115),
        ExhibitionData("우리 코코", "plataa", UIImage(named: "coco_phoster")!, [1, 2, 3], 312, 198)
    ]
    
    var isRightBarBtnExist = false
    var isOrderChanged = false
    var checkedOrder = 0
    let minimumLineSpacing: CGFloat = 25
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureCV()
    }
}

// MARK: - Configure
extension ExhibitionListVC {
    private func configureNavigationBar() {
        navigationController?.additionalSafeAreaInsets.top = 8
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "BackBtn"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(popVC))
        navigationController?.navigationBar.tintColor = .black
        
        setRightBarBtn()
    }
    
    private func configureCV() {
        exhibitionListCV.dataSource = self
        exhibitionListCV.delegate = self
        exhibitionListCV.register(UINib(nibName: Identifiers.exhibitionCVC, bundle: nil), forCellWithReuseIdentifier: Identifiers.exhibitionCVC)
        exhibitionListCV.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        exhibitionListCV.showsVerticalScrollIndicator = false
        if let layout = exhibitionListCV.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = .zero
        }
    }
}

// MARK: - Custom Methods
extension ExhibitionListVC {
    func setNaviBarTitle(_ title: String) {
        navigationItem.title = title
    }
    
    func setRightBarBtn() {
        if isRightBarBtnExist {
            let buttonWidth = 75
            let buttonHeight = 29
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight))
            
            button.backgroundColor = .clear
            button.setTitle("인기순 ", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.setImage(UIImage(named: "Reorder"), for: .normal)
            button.titleLabel?.font = .AppleSDGothicB(size: 12)
            button.semanticContentAttribute = .forceRightToLeft
            button.addTarget(self, action: #selector(presentBottomSheet), for: .touchUpInside)
            
            let rightBarButtonItem = UIBarButtonItem(customView: button)
            rightBarButtonItem.customView?.layer.borderColor = UIColor.label.cgColor
            rightBarButtonItem.customView?.layer.borderWidth = 1
            rightBarButtonItem.customView?.layer.cornerRadius = CGFloat(buttonHeight / 2)
            navigationItem.rightBarButtonItem = rightBarButtonItem
        }
    }
    
    @objc func presentBottomSheet(){
        let reorderBottomSheet = ReorderBottomSheetVC()
        reorderBottomSheet.delegate = self
        reorderBottomSheet.checkedOrder = checkedOrder
        self.present(reorderBottomSheet, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension ExhibitionListVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        exhibitionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.exhibitionCVC, for: indexPath) as? ExhibitionCVC else { return UICollectionViewCell() }
        cell.configureCell(exhibitionData[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension ExhibitionListVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ExhibitionCVC,
              let detailVC = UIStoryboard(name: Identifiers.detailSB, bundle: nil).instantiateViewController(withIdentifier: Identifiers.detailVC) as? DetailVC else { return }
        
        detailVC.exhibitionData = cell.exhibitionData
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ExhibitionListVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let widthPadding: CGFloat = 15

        let cellWidth = (width - widthPadding) / 2
        let cellHeight = 4 * cellWidth / 3 + 64

        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        minimumLineSpacing
    }
}

// MARK: - TVCellDelegate
extension ExhibitionListVC: TVCellDelegate {
    func selectedTVC(sortedBy index: Int) {
        let rightBarButton = self.navigationItem.rightBarButtonItem!
        let button = rightBarButton.customView as! UIButton
        
        if index == 0 {
            button.setTitle("인기순 ", for: .normal)
            // TODO: - 데이터 순서 정렬
        } else {
            button.setTitle("최신순 ", for: .normal)
            // TODO: - 데이터 순서 정렬
        }
        
        exhibitionListCV.reloadData()
        exhibitionListCV.scrollToItem(at: [0,0], at: .top, animated: true)
        checkedOrder = index
    }
}
