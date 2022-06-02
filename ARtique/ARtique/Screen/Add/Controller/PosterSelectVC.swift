//
//  PosterSelectVC.swift
//  ARtique
//
//  Created by 황윤경 on 2022/05/31.
//

import UIKit
import PhotoCropper
import Photos
import RxSwift
import RxCocoa
import RxGesture

class PosterSelectVC: BaseVC {
    @IBOutlet weak var dismissBtn: UIButton!
    @IBOutlet weak var savePosterBtn: UIButton!
    @IBOutlet weak var previewBase: UIView!
    @IBOutlet weak var galleryBaseView: UIView!
    @IBOutlet weak var verticalScrollBar: UIView!
    @IBOutlet weak var albumListButton: UIButton!
    @IBOutlet weak var galleryCV: UICollectionView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    private var preview = PhotoCropperView()
    private var spiner = UIActivityIndicatorView()
    var delegate: SelectPoster?
    let imageManager = PHCachingImageManager()
    var devicePhotos: PHFetchResult<PHAsset>!
    var albumList = [PHAssetCollection]()
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavibar()
        bindDoneButton()
        bindOutput()
        getAlbums()
        configurePreview()
        configureLoading()
        configureAlbumListButton()
        configureCV()
        addDragGesture()
    }
    
    @IBAction func showAlbumList(_ sender: Any) {
        let albumListVC = UIStoryboard(name: Identifiers.albumListTVC, bundle: nil).instantiateViewController(withIdentifier: Identifiers.albumListTVC) as! AlbumListTVC
        albumListVC.delegate = self
        albumListVC.albumList = albumList
        
        self.present(albumListVC, animated: true, completion: nil)
    }
}

// MARK: - Protocol
protocol SelectPoster {
    func selectPoster(with image: UIImage)
}

// MARK: - Configure
extension PosterSelectVC {
    private func configureNavibar() {
        savePosterBtn.backgroundColor = .black
        savePosterBtn.setTitle("완료", for: .normal)
        savePosterBtn.setTitleColor(.white, for: .normal)
        savePosterBtn.titleLabel?.font = .AppleSDGothicB(size: 12)
        savePosterBtn.layer.cornerRadius = savePosterBtn.frame.height / 2       
        dismissBtn.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
    }
    
    private func configurePreview() {
        previewBase.addSubview(preview)
        preview.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        BehaviorRelay(value: 3.0 / 4.0)
            .bind(to: PhotoCropper.shared.ratio)
            .disposed(by: bag)
        
        preview.scrollView.alwaysBounceVertical = true
        preview.scrollView.alwaysBounceHorizontal = true
        preview.layer.borderColor = UIColor.black.cgColor
        preview.layer.borderWidth = 7
        setPreviewImage([0,0])
    }
    
    private func configureLoading() {
        preview.addSubview(spiner)
        spiner.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
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
        galleryCV.register(BorderCVC.self, forCellWithReuseIdentifier: Identifiers.borderCVC)
        galleryCV.dataSource = self
        galleryCV.delegate = self
        galleryCV.allowsMultipleSelection = false
        verticalScrollBar.layer.cornerRadius = verticalScrollBar.frame.height
    }
    
    private func bindDoneButton() {
        savePosterBtn.rx.tap
            .bind(to: preview.crop)
            .disposed(by: bag)
    }
    
    private func bindOutput() {
        preview.resultImage
            .subscribe(onNext: { [weak self] image in
                guard let self = self else { return }
                if self.galleryCV.indexPathsForSelectedItems?.count == 0 {
                    self.popupToast(toastType: .choosePoster)
                } else {
                    self.delegate?.selectPoster(with: image ?? UIImage())
                    self.dismiss(animated: true, completion: nil)
                }
            })
            .disposed(by: bag)
    }
}

// MARK: - Custom Methods
extension PosterSelectVC {
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
                        isDegraded ? self.spiner.startAnimating() : self.spiner.stopAnimating()
                    }
                }
            }
        }
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
        let constant = isHidden ? -self.previewBase.frame.height : 0
        
        UIView.animate(withDuration: 0.4, delay: 0, options: UIView.AnimationOptions(), animations: {
            self.topConstraint.constant = constant
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

// MARK: - Protocol
extension PosterSelectVC: AlbumChangeDelegate {
    func changeAlbum(albumNum: Int) {
        if !albumList.isEmpty {
            let collection = albumList[albumNum]
            fetchAssets(with: collection)
            albumListButton.setTitle(collection.localizedTitle ?? "", for: .normal)
            galleryCV.reloadData()
            galleryCV.scrollToItem(at: [0,0], at: .top, animated: false)
            setPreviewImage([0,0])
        }
    }
}

// MARK: - UICollectionViewDataSource
extension PosterSelectVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        devicePhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.borderCVC, for: indexPath) as? BorderCVC else { return UICollectionViewCell() }
        let asset = devicePhotos.object(at: indexPath.item)
        imageManager.requestImage(for: asset,
                                     targetSize: cell.frame.size,
                                     contentMode: .aspectFill,
                                     options: nil) { (image, _) in
            cell.configureCell(image:image ?? UIImage(), borderWidth: 4)
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension PosterSelectVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        setPreviewImage(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let cell = collectionView.cellForItem(at: indexPath) as? BorderCVC else { return true }
        if cell.isSelected {
            collectionView.deselectItem(at: indexPath, animated: true)
            return false
        } else {
            return true
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PosterSelectVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/3.2,
                      height: collectionView.frame.width/3.2)
    }
}
