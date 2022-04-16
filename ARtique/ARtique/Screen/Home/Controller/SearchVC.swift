//
//  SearchVC.swift
//  ARtique
//
//  Created by 황윤경 on 2022/04/16.
//

import UIKit

class SearchVC: UIViewController {
    @IBOutlet weak var recommendCV: UICollectionView!
    @IBOutlet weak var latestCV: UICollectionView!
    let recommendData = ["제주고양이", "Love Love Love", "The Cat"]
    let latestData = ["우리 코코", "사랑스러운", "Photo"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNaviBar()
        configureCV()
    }
}

// MARK: - Configure
extension SearchVC {
    private func configureNaviBar() {
        navigationController?.additionalSafeAreaInsets.top = 8
        navigationItem.title = "검색"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "BackBtn"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(popVC))
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func configureCV() {
        recommendCV.dataSource = self
        recommendCV.delegate = self
        
        latestCV.dataSource = self
        latestCV.delegate = self
        if let layout = latestCV.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
    }
}

// MARK: - Custom Methods
extension SearchVC {
    @objc func popVC() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension SearchVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case recommendCV:
            return 3
        case latestCV:
            return 3
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let recommandCell = recommendCV.dequeueReusableCell(withReuseIdentifier: "RecommendCVC", for: indexPath) as? RecommendCVC,
              let latestCell = latestCV.dequeueReusableCell(withReuseIdentifier: Identifiers.latestSearchedCVC, for: indexPath) as? LatestSearchedCVC else { return UICollectionViewCell() }
        
        switch collectionView {
        case recommendCV:
            recommandCell.configureCell(with: recommendData[indexPath.row])
            return recommandCell
        case latestCV:
            latestCell.configureCell(with: latestData[indexPath.row])
            return latestCell
        default:
            return UICollectionViewCell()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SearchVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
}
