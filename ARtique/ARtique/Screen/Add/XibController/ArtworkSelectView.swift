//
//  ArtworkSelectView.swift
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

class ArtworkSelectView: UIView {
    @IBOutlet weak var viewTitle: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var previewBaseView: UIView!
    @IBOutlet weak var galleryBaseView: UIView!
    @IBOutlet weak var verticalScrollBar: UIView!
    @IBOutlet weak var galleryCV: UICollectionView!
    @IBOutlet weak var albumListButton: UIButton!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    var preview = PhotoCropperView()
    private var spiner = UIActivityIndicatorView()
    
    let imageManager = PHCachingImageManager()
    var devicePhotos: PHFetchResult<PHAsset>!
    var albumList = [PHAssetCollection]()
    
    let bag = DisposeBag()
    let exhibitionModel = NewExhibition.shared
    var selectedImages = [UIImage]()
    var selectedIndex: IndexPath?
    var indexArr = [Int]()
    var isEdited: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setContentView()
        layoutView()
        setNotification()
        getAlbums()
        configureViewTitle()
        configurePreview()
        configureLoading()
        configureAlbumListButton()
        configureCV()
        addDragGesture()
        saveCropImage()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setContentView()
        layoutView()
        setNotification()
        getAlbums()
        configureViewTitle()
        configurePreview()
        configureLoading()
        configureAlbumListButton()
        configureCV()
        addDragGesture()
        saveCropImage()
    }
    
    @IBAction func showAlbumList(_ sender: Any) {
        NotificationCenter.default.post(name: .whenAlbumListBtnSelected, object: albumList)
    }
}

// MARK: - Configure
extension ArtworkSelectView {
    private func setContentView() {
        guard let view = loadXibView(with: Identifiers.artworkSelectView) else { return }
        view.backgroundColor = .clear
        self.addSubview(view)
        
        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func layoutView() {
        previewBaseView.snp.makeConstraints {
            $0.height.equalTo(previewBaseView.snp.width).offset(89 - 40)
        }
        previewBaseView.addSubview(preview)
        preview.snp.makeConstraints {
            $0.top.equalToSuperview().offset(89)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview()
        }
        
        preview.addSubview(spiner)
        spiner.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configureViewTitle() {
        viewTitle.text = "사진선택 (\(galleryCV.indexPathsForSelectedItems?.count ?? 0)/\(exhibitionModel.gallerySize ?? 0))"
    }
    
    private func configurePreview() {
        preview.scrollView.alwaysBounceVertical = true
        preview.scrollView.alwaysBounceHorizontal = true
        preview.layer.borderColor = UIColor.black.cgColor
        preview.layer.borderWidth = 7
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
extension ArtworkSelectView {
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
        }
    }
    
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
                        self.preview.imageView.image = image
                        self.preview.scrollView.zoomScale = self.preview.scrollView.minimumZoomScale
                        self.preview.updateZoomScale()
                        self.selectedIndex = indexPath
                        guard let cell = self.galleryCV.cellForItem(at: indexPath) as? GalleryCVC else { return }
                        isDegraded ? self.spiner.startAnimating() : self.spiner.stopAnimating()
                        if self.spiner.isAnimating { cell.selectedIndex.text = "" }
                        if !isDegraded && (self.galleryCV.indexPathsForSelectedItems?.count ?? 0) != 0
                            && !self.spiner.isAnimating && cell.isSelected {
                            self.preview.crop.onNext(())
                            self.isEdited = false
                        }
                    }
                }
            }
        }
    }
    
    private func saveCropImage() {
        preview.scrollView.rx.didEndDecelerating
            .map { _ in
                self.isEdited = true
            }
            .bind(to: preview.crop)
            .disposed(by: bag)
        
        preview.rx.pinchGesture()
            .when(.ended)
            .map { _ in
                self.isEdited = true
            }
            .bind(to: preview.crop)
            .disposed(by: bag)
        
        preview.resultImage
            .subscribe(onNext: { [weak self] image in
                guard let self = self,
                      let selectedIndex = self.selectedIndex,
                      let cell = self.galleryCV.cellForItem(at: selectedIndex) as? GalleryCVC else { return }
                if self.indexArr.contains(selectedIndex.row) { return }
                if self.isEdited {
                    if self.selectedImages.isEmpty {
                        self.galleryCV.selectItem(at: selectedIndex, animated: true, scrollPosition: .top)
                        cell.setSelectedIndex(1)
                    } else {
                        self.selectedImages.removeLast()
                        self.indexArr.removeLast()
                    }
                } else {
                    cell.setSelectedIndex(self.selectedImages.count + 1)
                }
                if self.selectedImages.count >= self.exhibitionModel.gallerySize ?? 0 { return }
                self.configureViewTitle()
                self.indexArr.append((selectedIndex).row)
                self.selectedImages.append(image ?? UIImage())
            })
            .disposed(by: bag)
    }
    
    private func addDragGesture() {
        let galleryVerticalScrollGesture = UIPanGestureRecognizer(target: self, action: #selector(galleryVerticalScroll))
        galleryBaseView.addGestureRecognizer(galleryVerticalScrollGesture)
    }
    
    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(changeAlbum), name: .whenAlbumChanged, object: nil)
    }
    
    @objc func changeAlbum(_ notification: Notification) {
        if !albumList.isEmpty {
            let collection = albumList[notification.object as! Int]
            fetchAssets(with: collection)
            albumListButton.setTitle(collection.localizedTitle ?? "", for: .normal)
            selectedImages.removeAll()
            indexArr.removeAll()
            configureViewTitle()
            galleryCV.indexPathsForSelectedItems?.forEach({ galleryCV.deselectItem(at: $0, animated: false) })
            galleryCV.reloadData()
            galleryCV.scrollToItem(at: [0,0], at: .top, animated: false)
            setPreviewImage([0,0])
        }
    }
    
    @objc func galleryVerticalScroll(sender: UIPanGestureRecognizer) {
        let dragPosition = sender.translation(in: self)
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
            self.layoutIfNeeded()
        }, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource
extension ArtworkSelectView: UICollectionViewDataSource {
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
            
            guard let items = collectionView.indexPathsForSelectedItems else { return }
            if items.contains(indexPath) {
                cell.setSelectedIndex((self.indexArr.firstIndex(of: indexPath.row) ?? 0) + 1)
            }
        }
        
        return cell
    }
}

//MARK: UICollectionViewDelegate
extension ArtworkSelectView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? GalleryCVC,
              let selectedIndex = cell.selectedIndex.text,
              let index = Int(selectedIndex) else {
                  spiner.stopAnimating()
                  return
              }
        
        if spiner.isAnimating {
            spiner.stopAnimating()
            return
        }
        
        indexArr.remove(at: index - 1)
        selectedImages.remove(at: index - 1)
        spiner.stopAnimating()
        configureViewTitle()
        
        collectionView.indexPathsForSelectedItems?.forEach {
            guard let restCell = collectionView.cellForItem(at: $0) as? GalleryCVC,
                  let index = restCell.selectedIndex.text,
                  let cellIndex = cell.selectedIndex.text else { return }
            if Int(index)! > Int(cellIndex)! {
                restCell.selectedIndex.text = "\(Int(restCell.selectedIndex.text!)! - 1)"
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if selectedImages.count >= exhibitionModel.gallerySize ?? 0
            || (spiner.isAnimating && indexPath != selectedIndex)
            || preview.scrollView.isDecelerating {
            return false
        } else {
            setPreviewImage(indexPath)
            previewStatus(isHidden: self.topConstraint.constant == 0 ? false : true)
            return true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        guard let isContains = collectionView.indexPathsForSelectedItems?.contains(indexPath) else { return true }
        if spiner.isAnimating && isContains && indexPath != selectedIndex {
            return false
        } else {
            return true
        }
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension ArtworkSelectView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/3.2,
                      height: collectionView.frame.width/3.2)
    }
}

// MARK: - UIScrollViewDelegate
extension ArtworkSelectView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.velocity(in: scrollView).y < -3000 {
            previewStatus(isHidden: true)
        } else if scrollView.panGestureRecognizer.velocity(in: scrollView).y > 3000 {
            previewStatus(isHidden: false)
        }
    }
}
