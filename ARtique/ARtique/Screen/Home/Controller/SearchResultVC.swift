//
//  SearchResultVC.swift
//  ARtique
//
//  Created by 황윤경 on 2022/04/17.
//

import UIKit
import SnapKit

class SearchResultVC: BaseVC {
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var resultCV: UICollectionView!
    var searchCnt: Int?
    var keyword: String?
    let minimumLineSpacing: CGFloat = 25
    
    var exhibitionData: [ExhibitionModel]?
    
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
        resultLabel.text = searchCnt == 0
        ? "'\(keyword ?? "")' 에 해당하는 전시를 찾지 못했어요"
        : "'\(keyword ?? "")' 에 대한 검색 결과"
        
        resultLabel.font = .AppleSDGothicSB(size: 17)
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
            $0.height.equalTo(CGFloat(searchCnt ?? 0) * (height + minimumLineSpacing))
        }
    }
}

// MARK: - UICollectionViewDataSource
extension SearchResultVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        exhibitionData?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.exhibitionCVC, for: indexPath) as? ExhibitionCVC else { return UICollectionViewCell() }

        cell.configureCell(exhibitionData?[indexPath.row] ?? ExhibitionModel())
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension SearchResultVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let detailVC = UIStoryboard(name: Identifiers.detailSB, bundle: nil).instantiateViewController(withIdentifier: Identifiers.detailVC) as? DetailVC,
              let cell = collectionView.cellForItem(at: indexPath) as? ExhibitionCVC else { return }
        detailVC.exhibitionID = cell.exhibitionData?.exhibitionId
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SearchResultVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let widthPadding: CGFloat = 15

        let cellWidth = (width - widthPadding) / 2
        let cellHeight = 4 * cellWidth / 3 + 64

        layoutCV(with: cellHeight)
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        minimumLineSpacing
    }
}
