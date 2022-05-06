//
//  PostExplainView.swift
//  ARtique
//
//  Created by 황윤경 on 2022/03/22.
//

import UIKit
import SnapKit

class PostExplainView: UIView {
    @IBOutlet weak var baseSV: UIScrollView!
    @IBOutlet weak var artworkExplainCV: UICollectionView!
    
    var currentIndex:CGFloat = 0
    let cellWidth: CGFloat = 300
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setContentView()
        configureLayout()
        configureCV()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setContentView()
        configureLayout()
        configureCV()
    }
}

// MARK: - Configure
extension PostExplainView {
    private func setContentView() {
        guard let view = loadXibView(with: Identifiers.postExplainView) else { return }
        view.backgroundColor = .clear
        self.addSubview(view)
        
        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configureCV() {
        artworkExplainCV.register(UINib(nibName: Identifiers.artworkExplainCVC, bundle: nil), forCellWithReuseIdentifier: Identifiers.artworkExplainCVC)
        artworkExplainCV.dataSource = self
        artworkExplainCV.delegate = self
        artworkExplainCV.contentInset = UIEdgeInsets(top: 0,
                                                     left: 20,
                                                     bottom: 0,
                                                     right: 20)
        artworkExplainCV.decelerationRate = .fast
        artworkExplainCV.showsHorizontalScrollIndicator = false
        if let layout = artworkExplainCV.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
    }
    
    private func configureLayout() {
        baseSV.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalToSuperview().offset(89)
        }
        
        artworkExplainCV.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(UIScreen.main.bounds.height - 170)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension PostExplainView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        NewExhibition.shared.selectedArtwork?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.artworkExplainCVC, for: indexPath) as? ArtworkExplainCVC else { return UICollectionViewCell() }
        cell.configureCell(index: indexPath.row)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PostExplainView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        12
    }
}

// MARK: - UICollectionViewDelegate
extension PostExplainView: UICollectionViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let cellWidthIncludeSpacing = cellWidth + 12
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
        
        offset = CGPoint(x: roundedIndex * cellWidthIncludeSpacing - scrollView.contentInset.left,
                         y: scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
}
