//
//  OrderVC.swift
//  ARtique
//
//  Created by 황윤경 on 2022/03/22.
//

import UIKit
import SnapKit

class OrderVC: UIViewController {
    @IBOutlet weak var selectedPhotoCV: UICollectionView!
    let exhibitionModel = NewExhibition.shared
    var artworkReorderDelegate: ReorderArtwork?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCV()
    }
}

// MARK: - Protocol
protocol ReorderArtwork {
    func reorderArtwork(sourceIndexPath: IndexPath, destinationIndexPath: IndexPath)
}

// MARK: - Configure
extension OrderVC {
    private func configureCV() {
        selectedPhotoCV.register(GalleryCVC.self, forCellWithReuseIdentifier: Identifiers.galleryCVC)
        selectedPhotoCV.dataSource = self
        selectedPhotoCV.delegate = self
        selectedPhotoCV.dragDelegate = self
        selectedPhotoCV.dropDelegate = self
        selectedPhotoCV.dragInteractionEnabled = true
        selectedPhotoCV.allowsSelection = false
        selectedPhotoCV.showsVerticalScrollIndicator = false
        selectedPhotoCV.contentInset = UIEdgeInsets(top: 0.0,
                                                    left: 20.0,
                                                    bottom: 0.0,
                                                    right: 20.0)
    }
}

// MARK: - Custom Methods
extension OrderVC {
    private func reorderItems(coordinator : UICollectionViewDropCoordinator, destinationIndexPath : IndexPath, collectionView : UICollectionView) {
        if let item = coordinator.items.first, let sourceIndexPath = item.sourceIndexPath {
            collectionView.performBatchUpdates({
                guard let item = exhibitionModel.artworks?.remove(at: sourceIndexPath.row) else { return }
                exhibitionModel.artworks?.insert(item, at: destinationIndexPath.row)
                
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [destinationIndexPath])
                
                artworkReorderDelegate?.reorderArtwork(sourceIndexPath: sourceIndexPath, destinationIndexPath: destinationIndexPath)
            }, completion: { _ in
                self.selectedPhotoCV.reloadItems(at: self.selectedPhotoCV.indexPathsForVisibleItems)
            })
            coordinator.drop(item.dragItem, toItemAt : destinationIndexPath)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension OrderVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        exhibitionModel.artworks?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.galleryCVC, for: indexPath) as? GalleryCVC else { return UICollectionViewCell() }
        cell.configureCell(with: exhibitionModel.artworks?[indexPath.row].image ?? UIImage())
        cell.setSelectedIndex(indexPath.row + 1)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension OrderVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.frame.width - 40) / 3.2
        return CGSize(width: cellWidth, height: cellWidth)
    }
}

// MARK: - UICollectionViewDelegate
extension OrderVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, canEditItemAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        true
    }
}

// MARK: - UICollectionViewDragDelegate, UICollectionViewDropDelegate
extension OrderVC: UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let nsItemProvider = NSItemProvider(object: "" as NSString)
        let dragItem = UIDragItem(itemProvider: nsItemProvider)
        collectionView.cellForItem(at: indexPath)?.isSelected = true
        
        return [dragItem]
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        var destinationIndexPath: IndexPath
        
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let row = collectionView.numberOfItems(inSection: 0)
            destinationIndexPath = IndexPath(item : row - 1, section: 0 )
        }
        
        if coordinator.proposal.operation == .move {
            reorderItems(coordinator: coordinator,
                         destinationIndexPath: destinationIndexPath,
                         collectionView: collectionView)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if collectionView.hasActiveDrag {
            return UICollectionViewDropProposal(operation: .move,
                                                intent: .insertAtDestinationIndexPath)
        }
        
        return UICollectionViewDropProposal(operation: .forbidden)
    }
}
