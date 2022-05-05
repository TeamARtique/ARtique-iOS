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

class ArtworkSelectView: UIView {
    @IBOutlet weak var previewBaseView: UIView!
    @IBOutlet weak var galleryBaseView: UIView!
    @IBOutlet weak var galleryCV: UICollectionView!
    @IBOutlet weak var albumListButton: UIButton!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    var preview = PhotoCropperView()
    private var spiner = UIActivityIndicatorView()
    
    var devicePhotos: PHFetchResult<PHAsset>!
    let imageManager = PHCachingImageManager()
    var albumList = [PHAssetCollection]()
    
    let bag = DisposeBag()
    let exhibitionModel = NewExhibition.shared
    var maxArtworkCnt: Int = 0
    var selectedImages = [UIImage]()
    var selectedImageIds = [String]()
    var isFirstSelection = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setContentView()
        layoutView()
        setNotification()
        getAlbums()
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
        topConstraint.constant = 20

        previewBaseView.addSubview(preview)
        preview.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        preview.addSubview(spiner)
        spiner.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
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
    
    private func setPreviewImage(_ indexPath: IndexPath) {
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
                        isDegraded ? self.spiner.startAnimating() : self.spiner.stopAnimating()
                    }
                }
            }
        }
    }
    
    private func saveCropImage() {
        galleryCV.rx.itemSelected
            .map ({_ in})
            .bind(to: preview.crop)
            .disposed(by: bag)
        
        preview.resultImage
            .subscribe(onNext: { [weak self] image in
                guard let self = self else { return }
                if !self.isFirstSelection {
                    self.selectedImages.append(image ?? UIImage())
                    self.exhibitionModel.selectedArtwork = self.selectedImages
                }
                // TODO: - ERROR
                self.isFirstSelection = false
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
        UIView.animate(withDuration: 0.4, delay: 0, options: UIView.AnimationOptions(), animations: {
            if isHidden {
                self.previewBaseView.layer.opacity = 0
                self.topConstraint.constant = -self.previewBaseView.frame.height
            } else {
                self.previewBaseView.layer.opacity = 1
                self.topConstraint.constant = 20
            }
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
        
        cell.id = asset.localIdentifier
        
        imageManager.requestImage(for: asset, targetSize: cell.frame.size, contentMode: .aspectFill, options: nil) { (image, _) in
            cell.configureCell(with: image ?? UIImage())
        }
        
        return cell
    }
}

//MARK: UICollectionViewDelegate
extension ArtworkSelectView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? GalleryCVC else { return }
        cell.isSet = true
        selectedImageIds.append(cell.id)
        cell.setSelectedIndex(selectedImageIds.count)
        previewStatus(isHidden: false)
        galleryCV.scrollToItem(at: indexPath, at: .top, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? GalleryCVC else { return }
        cell.isSet = false
        selectedImages.remove(at: selectedImageIds.firstIndex(of: cell.id)!)
        selectedImageIds.remove(at: selectedImageIds.firstIndex(of: cell.id)!)
        exhibitionModel.selectedArtwork = selectedImages
        spiner.stopAnimating()
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if spiner.isAnimating { return false }
        
        setPreviewImage(indexPath)
        if collectionView.indexPathsForSelectedItems!.count >= maxArtworkCnt {
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
