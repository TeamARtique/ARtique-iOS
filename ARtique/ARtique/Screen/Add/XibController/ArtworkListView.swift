//
//  SelectedImageCV.swift
//  ARtique
//
//  Created by 황윤경 on 2022/03/22.
//

import UIKit

class ArtworkListView: UIView {
    @IBOutlet weak var artworkCV: UICollectionView!
    var dummyImages = [UIImage(named: "Theme1"),
                       UIImage(named: "Theme2"),
                       UIImage(named: "Theme3"),
                       UIImage(named: "Theme4"),
                       UIImage(named: "Theme1")]
    let spacing: CGFloat = 12
    var currentIndex:CGFloat = 0
    let cellWidth: CGFloat = 300
    var isOrderView = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setContentView()
        configureCV()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setContentView()
        configureCV()
    }
    
    private func setContentView() {
        guard let view = loadXibView(with: Identifiers.artworkListView) else { return }
        view.backgroundColor = .clear
        self.addSubview(view)
        
        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configureCV() {
        artworkCV.register(UINib(nibName: Identifiers.selectedImageCVC, bundle: nil), forCellWithReuseIdentifier: Identifiers.selectedImageCVC)
        artworkCV.register(UINib(nibName: Identifiers.artworkExplainCVC, bundle: nil), forCellWithReuseIdentifier: Identifiers.artworkExplainCVC)
        
        artworkCV.dataSource = self
        artworkCV.delegate = self
        
        artworkCV.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        artworkCV.showsHorizontalScrollIndicator = false
        artworkCV.decelerationRate = UIScrollView.DecelerationRate.fast
        
        if let layout = artworkCV.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
    }
    
    func bindCVReorderGesture() {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        
        gesture.minimumPressDuration = 0.5
        artworkCV.addGestureRecognizer(gesture)
    }
    
    @objc func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        guard let collectionView = artworkCV else { return }
        guard let targetIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else { return }
        switch gesture.state {
        case .began:
            collectionView.beginInteractiveMovementForItem(at: targetIndexPath)
            collectionView.cellForItem(at: targetIndexPath)?.layer.borderColor = UIColor.black.cgColor
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: collectionView))
        case .ended:
            collectionView.endInteractiveMovement()
            collectionView.cellForItem(at: targetIndexPath)?.layer.borderColor = UIColor.clear.cgColor
            collectionView.scrollToItem(at: targetIndexPath, at: .left, animated: true)
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
}

extension ArtworkListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dummyImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let orderViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.selectedImageCVC, for: indexPath) as? SelectedImageCVC,
              let explainViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.artworkExplainCVC, for: indexPath) as? ArtworkExplainCVC
        else { return  UICollectionViewCell() }
        
        if isOrderView {
            orderViewCell.configureCell(with: dummyImages[indexPath.row] ?? UIImage())
            return orderViewCell
        } else {
            explainViewCell.configureCell(with: dummyImages[indexPath.row] ?? UIImage())
            return explainViewCell
        }
    }
}

extension ArtworkListView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth,
                      height: isOrderView ? cellWidth : collectionView.frame.height)
    }
}

extension ArtworkListView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, canEditItemAt indexPath: IndexPath) -> Bool {
        isOrderView ? true : false
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        isOrderView ? true : false
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = dummyImages.remove(at: sourceIndexPath.row)
        dummyImages.insert(item, at: destinationIndexPath.row)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let cellWidthIncludeSpacing = cellWidth + spacing
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