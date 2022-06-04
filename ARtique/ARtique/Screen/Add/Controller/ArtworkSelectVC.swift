//
//  ArtworkSelectVC.swift
//  ARtique
//
//  Created by 황윤경 on 2022/03/29.
//

import UIKit
import Photos
import PhotoCropper
import RxSwift
import RxCocoa
import SnapKit
import RxGesture

class ArtworkSelectVC: BaseVC {
    @IBOutlet weak var viewTitle: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var previewBaseView: UIView!
    @IBOutlet weak var galleryBaseView: UIView!
    @IBOutlet weak var verticalScrollBar: UIView!
    @IBOutlet weak var galleryCV: UICollectionView!
    @IBOutlet weak var albumListButton: UIButton!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    var preview = PhotoCropperView()
    var previewBorder = UIView()
    private var spiner = UIActivityIndicatorView()
    
    let imageManager = PHCachingImageManager()
    var devicePhotos: PHFetchResult<PHAsset>!
    var albumList = [PHAssetCollection]()
    
    let bag = DisposeBag()
    let exhibitionModel = NewExhibition.shared
    var selectedIndex: IndexPath?
    var indexArr = [[Int]]()
    var albumNum = 0
    var selectedImages = [SelectedImage]()
    var isEdited: Bool = false
    var selectLimitDelegate: ArtworkSelectDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutView()
        getAlbums()
        configureViewTitle()
        configurePreview()
        configureLoading()
        configureAlbumListButton()
        configureCV()
        addDragGesture()
        bindArtworkEdit()
        bindOutput()
    }
    
    @IBAction func showAlbumList(_ sender: Any) {
        guard let albumListVC = UIStoryboard(name: Identifiers.albumListTVC, bundle: nil).instantiateViewController(withIdentifier: Identifiers.albumListTVC) as? AlbumListTVC else { return }
        albumListVC.changeAlbumDelegate = self
        albumListVC.albumList = albumList
        
        present(albumListVC, animated: true)
    }
}

// MARK: - Configure
extension ArtworkSelectVC {
    private func layoutView() {
        previewBaseView.snp.makeConstraints {
            $0.height.equalTo(previewBaseView.snp.width).offset(89 - 40)
        }
        
        previewBaseView.addSubview(previewBorder)
        previewBorder.snp.makeConstraints {
            $0.top.equalToSuperview().offset(89)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview()
        }
        
        previewBaseView.addSubview(preview)
        preview.snp.makeConstraints {
            $0.top.equalToSuperview().offset(94)
            $0.leading.equalToSuperview().offset(25)
            $0.trailing.equalToSuperview().offset(-25)
            $0.height.equalTo(preview.snp.width)
        }
        
        preview.addSubview(spiner)
        spiner.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configureViewTitle() {
        viewTitle.text = "사진선택 (\(selectedImages.count)/\(exhibitionModel.gallerySize ?? 0))"
    }
    
    private func configurePreview() {
        preview.scrollView.alwaysBounceVertical = true
        preview.scrollView.alwaysBounceHorizontal = true
        preview.gridView.layer.borderWidth = 0
        previewBorder.layer.borderColor = UIColor.black.cgColor
        previewBorder.layer.borderWidth = 5
        setPreviewImage([0,0])
    }
    
    private func configureLoading() {
        spiner.backgroundColor = .white
        spiner.layer.opacity = 0.5
        spiner.color = .black
        spiner.style = .large
        spiner.hidesWhenStopped = true
    }
    
    private func configureAlbumListButton() {
        albumListButton.semanticContentAttribute = .forceRightToLeft
        albumListButton.setTitle("최근 항목", for: .normal)
        albumListButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        albumListButton.titleLabel?.baselineAdjustment = .alignCenters
        albumListButton.imageView?.layer.transform = CATransform3DMakeScale(0.7, 0.7, 0.7)
        albumListButton.tintColor = .black
        albumListButton.titleLabel?.font = .AppleSDGothicB(size: 13)
    }
    
    private func configureCV() {
        galleryCV.register(GalleryCVC.self, forCellWithReuseIdentifier: Identifiers.galleryCVC)
        galleryCV.dataSource = self
        galleryCV.delegate = self
        galleryCV.allowsMultipleSelection = true
        verticalScrollBar.layer.cornerRadius = verticalScrollBar.frame.height
    }
}

// MARK: - Custom Methods
extension ArtworkSelectVC {
    private func fetchAssets(with album: PHAssetCollection) {
        devicePhotos = PHAsset.fetchAssets(in: album, options: .descendingOptions)
    }
    
    private func getAlbums() {
        let options:PHFetchOptions = PHFetchOptions()
        let getAlbums : PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: options)
        let getSmartAlbums: PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: options)
        
        for i in 0 ..< getAlbums.count {
            if PHAsset.fetchAssets(in: getSmartAlbums[i], options: options).count == 0 { continue }
            albumList.append(getSmartAlbums[i])
        }
        
        for i in 0 ..< getAlbums.count {
            albumList.append(getAlbums[i])
        }
        
        if albumList.count == 0 {
            devicePhotos = PHAsset.fetchAssets(with: .descendingOptions)
        } else {
            fetchAssets(with: albumList[0])
            albumNum = 0
        }
    }
    
    /// galleryCV에서 선택된  indexPath를 받아 해당 원본 이미지를 preview로 지정해주는 함수,
    /// preview 로딩 완료 시 preview.crop 이벤트 발생
    func setPreviewImage(_ indexPath: IndexPath) {
        let width = devicePhotos.object(at: indexPath.row).pixelWidth
        let height = devicePhotos.object(at: indexPath.row).pixelHeight
        
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        DispatchQueue.global(qos: .background).async {
            PHImageManager.default().requestImage(for: self.devicePhotos.object(at: indexPath.row),
                                                     targetSize: CGSize(width: width,
                                                                        height: height),
                                                     contentMode: .aspectFit,
                                                     options: options) { (image, info) in
                let isDegraded = (info?[PHImageResultIsDegradedKey] as? Bool) ?? false
                if image != nil {
                    DispatchQueue.main.async {
                        isDegraded ? self.spiner.startAnimating() : self.spiner.stopAnimating()
                        self.preview.imageView.image = image
                        
                        if let index = self.indexArr.firstIndex(of: [self.albumNum, indexPath.row]) {
                            self.preview.scrollView.zoomScale = self.selectedImages[index].zoomScale
                            self.preview.scrollView.contentOffset = self.selectedImages[index].scrollOffset
                        } else {
                            self.preview.scrollView.zoomScale = self.preview.scrollView.minimumZoomScale
                        }
                        
                        self.preview.updateZoomScale()
                        self.selectedIndex = indexPath
                        
                        // preview 로딩 완료 & 처음 세팅되는 이미지가 아닐때 preview.crop 이벤트 발생
                        guard let cell = self.galleryCV.cellForItem(at: indexPath) as? GalleryCVC else { return }
                        if !isDegraded && (self.galleryCV.indexPathsForSelectedItems?.count ?? 0) != 0
                            && !self.spiner.isAnimating && cell.isSelected {
                            self.preview.crop.onNext(())
                        }
                    }
                }
            }
        }
    }
    
    /// 선택된 작품을 수정했을때 preview.crop 이벤트를 발생시키도록 bind
    private func bindArtworkEdit() {
        preview.scrollView.rx.didEndDecelerating
            .withUnretained(self)
            .map { _ in
                self.isEdited = true
            }
            .bind(to: preview.crop)
            .disposed(by: bag)
        
        preview.rx.panGesture()
            .when(.ended)
            .withUnretained(self)
            .map { _ in
                self.isEdited = true
            }
            .bind(to: preview.crop)
            .disposed(by: bag)
        
        preview.rx.pinchGesture()
            .when(.ended)
            .withUnretained(self)
            .map { _ in
                self.isEdited = true
            }
            .bind(to: preview.crop)
            .disposed(by: bag)
    }
    
    /// preview.crop 이벤트 발생 시 처리되는 부분
    private func bindOutput() {
        preview.resultImage
            .subscribe(onNext: { [weak self] image in
                guard let self = self,
                      let selectedIndex = self.selectedIndex,
                      let cell = self.galleryCV.cellForItem(at: selectedIndex) as? GalleryCVC else { return }
                if self.indexArr.contains([self.albumNum, selectedIndex.row]) && !self.isEdited { return }
                if self.isEdited {
                    if self.galleryCV.indexPathsForSelectedItems?.count == 0 {
                        self.galleryCV.selectItem(at: selectedIndex, animated: true, scrollPosition: .top)
                        cell.setSelectedIndex(self.selectedImages.count + 1)
                    } else {
                        let index = self.indexArr.firstIndex(of: [self.albumNum, selectedIndex.row])
                        self.indexArr.remove(at: index!)
                        self.indexArr.insert([self.albumNum, selectedIndex.row], at: index!)
                        self.selectedImages.remove(at: index!)
                        self.selectedImages.insert(SelectedImage(image: image ?? UIImage(),
                                                                 zoomScale: self.preview.scrollView.zoomScale,
                                                                 scrollOffset: self.preview.scrollView.contentOffset),
                                                   at: index!)
                        return
                    }
                } else {
                    cell.setSelectedIndex(self.selectedImages.count + 1)
                }
                if self.selectedImages.count >= self.exhibitionModel.gallerySize ?? 0 { return }
                self.indexArr.append([self.albumNum, selectedIndex.row])
                self.selectedImages.append(SelectedImage(image: image ?? UIImage(),
                                                         zoomScale: self.preview.scrollView.zoomScale,
                                                         scrollOffset: self.preview.scrollView.contentOffset))
                self.configureViewTitle()
            })
            .disposed(by: bag)
    }
    
    private func addDragGesture() {
        let galleryVerticalScrollGesture = UIPanGestureRecognizer(target: self, action: #selector(galleryVerticalScroll))
        galleryBaseView.addGestureRecognizer(galleryVerticalScrollGesture)
    }
    
    @objc func galleryVerticalScroll(sender: UIPanGestureRecognizer) {
        let dragPosition = sender.translation(in: self.view)
        if dragPosition.y < 0 {
            previewStatus(isHidden: true)
        } else {
            previewStatus(isHidden: false)
        }
    }
    
    private func previewStatus(isHidden: Bool) {
        let constant = isHidden ? -self.previewBaseView.frame.height : 0
        
        UIView.animate(withDuration: 0.4, delay: 0, options: UIView.AnimationOptions(), animations: {
            self.topConstraint.constant = constant
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func reloadContentView() {
        BehaviorRelay(value: 1 / 1)
            .bind(to: PhotoCropper.shared.ratio)
            .disposed(by: bag)
    }
    
    private func focusEditCell(collectionView: UICollectionView, indexPath: IndexPath) {
        guard let selectingCell = collectionView.cellForItem(at: indexPath) as? GalleryCVC,
                let otherCell = collectionView.visibleCells as? [GalleryCVC] else { return }
        otherCell.forEach {
            $0.setSelectedOverlay(isEditing: false)
        }
        selectingCell.setSelectedOverlay(isEditing: true)
    }
}

// MARK: - Protocol
extension ArtworkSelectVC: ReorderArtwork {
    func reorderArtwork(sourceIndexPath: IndexPath, destinationIndexPath: IndexPath) {
        let index = indexArr.remove(at: sourceIndexPath.row)
        indexArr.insert(index, at: destinationIndexPath.row)
        
        let image = selectedImages.remove(at: sourceIndexPath.row)
        selectedImages.insert(image, at: destinationIndexPath.row)
        
        galleryCV.indexPathsForSelectedItems?.forEach {
            guard let cell = galleryCV.cellForItem(at: $0) as? GalleryCVC else { return }
            cell.setSelectedIndex((indexArr.firstIndex(of: [albumNum, $0.row]) ?? 0) + 1)
        }
    }
}

extension ArtworkSelectVC: AlbumChangeDelegate {
    func changeAlbum(albumNum: Int) {
        if !albumList.isEmpty {
            let collection = albumList[albumNum]
            self.albumNum = albumNum
            fetchAssets(with: collection)
            albumListButton.setTitle(collection.localizedTitle ?? "", for: .normal)
            galleryCV.indexPathsForSelectedItems?.forEach({ galleryCV.deselectItem(at: $0, animated: false) })
            galleryCV.reloadData()
            galleryCV.scrollToItem(at: [0,0], at: .top, animated: false)
            setPreviewImage([0,0])
        }
    }
}

// MARK: - Protocol
protocol ArtworkSelectDelegate {
    func photoLimitToast()
}

// MARK: - UICollectionViewDataSource
extension ArtworkSelectVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        devicePhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.galleryCVC, for: indexPath) as? GalleryCVC else { return UICollectionViewCell() }
        let asset = devicePhotos.object(at: indexPath.item)
        imageManager.requestImage(for: asset,
                                     targetSize: cell.frame.size,
                                     contentMode: .aspectFill,
                                     options: nil) { [weak self] (image, _) in
            guard let self = self else { return }
            cell.configureCell(with: image ?? UIImage())
            cell.isSelected = false
            
            var selectedIndex = [Int]()
            self.indexArr.forEach {
                if $0[0] == self.albumNum {
                    selectedIndex.append($0[1])
                }
            }
            
            if selectedIndex.contains(indexPath.row) {
                cell.setSelectedIndex((self.indexArr.firstIndex(of: [self.albumNum, indexPath.row]) ?? 0) + 1)
                cell.isSelected = true
                self.galleryCV.selectItem(at: indexPath, animated: false, scrollPosition: .init())
            }
        }
        
        return cell
    }
}

//MARK: UICollectionViewDelegate
extension ArtworkSelectVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? GalleryCVC,
              let selectedIndex = cell.selectedIndex.text,
              let index = Int(selectedIndex) else {
                  spiner.stopAnimating()
                  return
              }
        
        if !indexArr.contains([albumNum, indexPath.row]) && spiner.isAnimating {
            spiner.stopAnimating()
            return
        }
        
        indexArr.remove(at: index - 1)
        selectedImages.remove(at: index - 1)
        spiner.stopAnimating()
        configureViewTitle()
        
        collectionView.indexPathsForSelectedItems?.forEach {
            guard let restCell = collectionView.cellForItem(at: $0) as? GalleryCVC,
                  let index = Int(restCell.selectedIndex.text ?? ""),
                  let cellIndex = Int(cell.selectedIndex.text ?? "") else { return }
            if index > cellIndex {
                restCell.selectedIndex.text = "\(Int(restCell.selectedIndex.text!)! - 1)"
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if selectedImages.count >= exhibitionModel.gallerySize ?? 0 {
            selectLimitDelegate?.photoLimitToast()
            return false
        }
        if (spiner.isAnimating && indexPath != selectedIndex)
            || preview.scrollView.isDecelerating {
            return false
        } else {
            isEdited = false
            setPreviewImage(indexPath)
            focusEditCell(collectionView: collectionView, indexPath: indexPath)
            return true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        guard let isContains = collectionView.indexPathsForSelectedItems?.contains(indexPath) else { return true }
        if spiner.isAnimating && isContains && indexPath != selectedIndex {
            return false
        } else if selectedIndex == indexPath {
            return true
        } else {
            isEdited = true
            setPreviewImage(indexPath)
            focusEditCell(collectionView: collectionView, indexPath: indexPath)
            return false
        }
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension ArtworkSelectVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/3.2,
                      height: collectionView.frame.width/3.2)
    }
}

// MARK: - UIScrollViewDelegate
extension ArtworkSelectVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.velocity(in: scrollView).y < -3000 {
            previewStatus(isHidden: true)
        } else if scrollView.panGestureRecognizer.velocity(in: scrollView).y > 3000 {
            previewStatus(isHidden: false)
        }
    }
}
