//
//  SearchResultVC.swift
//  ARtique
//
//  Created by 황윤경 on 2022/04/17.
//

import UIKit
import SnapKit

class SearchResultVC: UIViewController {
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var resultCV: UICollectionView!
    var searchCnt: Int?
    var keyword: String?
    
    let exhibitionData = [
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNaviBar()
        configureResultLabel()
        configureCV()
    }
}

// MARK: - Configure
extension SearchResultVC {
    private func configureNaviBar() {
        navigationController?.additionalSafeAreaInsets.top = 8
        navigationItem.title = "검색 결과 \(searchCnt ?? 0)"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "BackBtn"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(popVC))
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func configureResultLabel() {
        if searchCnt == 0 {
            resultLabel.text = "'\(keyword ?? "")' 에 해당하는 전시를 찾지 못했어요"
            resultLabel.font = .AppleSDGothicL(size: 15)
        } else {
            resultLabel.text = "'\(keyword ?? "")' 에 대한 검색 결과"
            resultLabel.font = .AppleSDGothicSB(size: 17)
        }
    }
    
    private func configureCV() {
        resultCV.register(UINib(nibName: Identifiers.exhibitionCVC, bundle: nil), forCellWithReuseIdentifier: Identifiers.exhibitionCVC)
        resultCV.dataSource = self
        resultCV.delegate = self
        resultCV.isScrollEnabled = false
        if let layout = resultCV.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = .zero
        }
    }
    
    private func layoutCV(with height: CGFloat) {
        resultCV.snp.makeConstraints {
            $0.height.equalTo(CGFloat(searchCnt ?? 0) * height)
        }
    }
}

// MARK: - Custom Methods
extension SearchResultVC {
    @objc func popVC() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension SearchResultVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        exhibitionData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.exhibitionCVC, for: indexPath) as? ExhibitionCVC else { return UICollectionViewCell() }

        cell.phoster.image = exhibitionData[indexPath.row].phoster
        cell.title.text = exhibitionData[indexPath.row].title
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SearchResultVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let widthPadding: CGFloat = 15

        let cellWidth = (width - widthPadding) / 2
        let cellHeight = 4 * cellWidth / 3 + 50

        layoutCV(with: cellHeight)
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
