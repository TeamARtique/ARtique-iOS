//
//  SelectedImageCV.swift
//  ARtique
//
//  Created by 황윤경 on 2022/03/22.
//

import UIKit

class SelectedImageView: UIView {
    @IBOutlet weak var selectedImageCV: UICollectionView!
    let spacing: CGFloat = 12
    var dummyImages = [UIImage(named: "Theme1"),
                       UIImage(named: "Theme2"),
                       UIImage(named: "Theme3"),
                       UIImage(named: "Theme4"),
                       UIImage(named: "Theme1")]
    var currentIndex:CGFloat = 0
    
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
        guard let view = loadXibView(with: Identifiers.selectedImageView) else { return }
        view.backgroundColor = .clear
        self.addSubview(view)
        
        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configureCV() {
        selectedImageCV.register(UINib(nibName: Identifiers.selectedImageCVC, bundle: nil), forCellWithReuseIdentifier: Identifiers.selectedImageCVC)
        
        selectedImageCV.dataSource = self
        selectedImageCV.delegate = self
        
        selectedImageCV.showsHorizontalScrollIndicator = false
        selectedImageCV.decelerationRate = UIScrollView.DecelerationRate.fast
        
        if let layout = selectedImageCV.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        
        gesture.minimumPressDuration = 0.5
        selectedImageCV.addGestureRecognizer(gesture)
    }
    
    @objc func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        guard let collectionView = selectedImageCV else { return }
        guard let targetIndexPath = collectionView.indexPathForItem(at: gesture .location(in: collectionView)) else { return }

        switch gesture.state {
        case .began:
            collectionView.beginInteractiveMovementForItem(at: targetIndexPath)
            collectionView.cellForItem(at: targetIndexPath)?.layer.borderColor = UIColor.red.cgColor
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: collectionView))
        case .ended:
            collectionView.endInteractiveMovement()
            collectionView.cellForItem(at: targetIndexPath)?.layer.borderColor = UIColor.clear.cgColor
            collectionView.scrollToItem(at: targetIndexPath, at: .centeredHorizontally, animated: true)
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
}

extension SelectedImageView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dummyImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.selectedImageCVC, for: indexPath) as? SelectedImageCVC else { return  UICollectionViewCell() }
        cell.image.image = dummyImages[indexPath.row]
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.layer.borderWidth = 5
        return cell
    }
}

extension SelectedImageView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 52,
                      height: collectionView.frame.width - 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
           return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
}

extension SelectedImageView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, canEditItemAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = dummyImages.remove(at: sourceIndexPath.row)
        dummyImages.insert(item, at: destinationIndexPath.row)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let cellWidthIncludeSpacing = selectedImageCV.frame.width - 55 + spacing
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
