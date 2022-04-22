//
//  MyExhibitionTVC.swift
//  ARtique
//
//  Created by 황윤경 on 2022/04/09.
//

import UIKit

class MyExhibitionTVC: UITableViewCell {
    @IBOutlet weak var exhibitionCV: UICollectionView!
    var exhibitionData: [ExhibitionData]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCV()
    }
}

// MARK: - Configure
extension MyExhibitionTVC {
    private func configureCV() {
        exhibitionCV.register(UINib(nibName: Identifiers.exhibitionCVC, bundle: nil), forCellWithReuseIdentifier: Identifiers.exhibitionCVC)
        exhibitionCV.dataSource = self
        exhibitionCV.delegate = self
        exhibitionCV.showsHorizontalScrollIndicator = false
        if let layout = exhibitionCV.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.estimatedItemSize = .zero
        }
        exhibitionCV.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
}

// MARK: - UICollectionViewDataSource
extension MyExhibitionTVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        exhibitionData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.exhibitionCVC, for: indexPath) as? ExhibitionCVC else { return UICollectionViewCell() }
        guard let exhibitionData = exhibitionData?[indexPath.row] else { return UICollectionViewCell() }
        cell.configureCell(exhibitionData)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MyExhibitionTVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 132,
                      height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        12
    }
}
