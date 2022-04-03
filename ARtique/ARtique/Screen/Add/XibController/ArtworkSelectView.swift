//
//  ArtworkSelectView.swift
//  ARtique
//
//  Created by 황윤경 on 2022/03/29.
//

import UIKit
import Photos
import PhotoCropper

class ArtworkSelectView: UIView {
    @IBOutlet weak var galleryCV: UICollectionView!
    @IBOutlet weak var albumListButton: UIButton!
    private var preview = PhotoCropperView()
    
    var devicePhotos: PHFetchResult<PHAsset>!
    let imageManager = PHCachingImageManager()
    
    let exhibitionModel = NewExhibition.shared
    var maxArtworkCnt: Int = 0
    var selectedImages = [UIImage]()
    var selectedImageIds = [String]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setContentView()
        fetchAssets()
        configurePreview()
        configureAlbumListButton()
        configureCV()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setContentView()
        fetchAssets()
        configurePreview()
        configureAlbumListButton()
        configureCV()
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
        view.addSubview(preview)
        layoutPreview()
    }
    
    private func layoutPreview() {
        preview.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(preview.snp.width)
            $0.bottom.equalTo(albumListButton.snp.top).offset(-12)
        }
    }
    
    private func configurePreview() {
        preview.scrollView.alwaysBounceVertical = true
        preview.scrollView.alwaysBounceHorizontal = true
        preview.layer.borderColor = UIColor.black.cgColor
        preview.layer.borderWidth = 7
        setPreviewImage([0,0])
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
        galleryCV.register(UINib(nibName: Identifiers.selectedImageCVC, bundle: nil),
                           forCellWithReuseIdentifier: Identifiers.selectedImageCVC)
        galleryCV.dataSource = self
        galleryCV.delegate = self
        galleryCV.allowsMultipleSelection = true
    }
}

// MARK: - Custom Methods
extension ArtworkSelectView {
    private func fetchAssets() {
        devicePhotos = PHAsset.fetchAssets(with: .descendingOptions)
    }
    
    private func setPreviewImage(_ indexPath: IndexPath) {
        let width = preview.frame.width
        let height = preview.frame.height
        
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .exact
        
        PHImageManager.default().requestImage(for: devicePhotos.object(at: indexPath.row),
                                                 targetSize: CGSize(width: width,
                                                                    height: height),
                                                 contentMode: .aspectFit, options: options) { (image, _) in
            if image != nil {
                self.preview.imageView.image = image
                self.preview.updateZoomScale()
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension ArtworkSelectView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        devicePhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.selectedImageCVC, for: indexPath) as? SelectedImageCVC else { return UICollectionViewCell() }
        
        let asset = devicePhotos.object(at: indexPath.item)
        
        cell.id = asset.localIdentifier
        cell.image.contentMode = .scaleAspectFill
        
        imageManager.requestImage(for: asset, targetSize: cell.frame.size, contentMode: .aspectFill, options: nil) { (image, _) in
            cell.configureCell(with: image ?? UIImage())
        }
        
        return cell
    }
}

//MARK: UICollectionViewDelegate
extension ArtworkSelectView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        setPreviewImage(indexPath)
        guard let cell = collectionView.cellForItem(at: indexPath) as? SelectedImageCVC else { return }
        cell.isSet = true
        selectedImageIds.append(cell.id)
        selectedImages.append(cell.image.image ?? UIImage())
        exhibitionModel.selectedArtwork = selectedImages
        NotificationCenter.default.post(name: .whenArtworkSelected, object: exhibitionModel.selectedArtwork?.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? SelectedImageCVC else { return }
        cell.isSet = false
        selectedImages.remove(at: selectedImageIds.firstIndex(of: cell.id)!)
        selectedImageIds.remove(at: selectedImageIds.firstIndex(of: cell.id)!)
        exhibitionModel.selectedArtwork = selectedImages
        NotificationCenter.default.post(name: .whenArtworkSelected, object: exhibitionModel.selectedArtwork?.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
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
