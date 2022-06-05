//
//  ArtistProfileVC.swift
//  ARtique
//
//  Created by 황윤경 on 2022/05/30.
//

import UIKit

class ArtistProfileVC: BaseVC {
    @IBOutlet weak var exhibitionListCV: UICollectionView!
    
    var artistID: Int?
    var artistData: ArtistProfileModel?
    let minimumLineSpacing: CGFloat = 25
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let artistID = artistID else { return }
        getArtistProfile(artistID: artistID)
    }
}

// MARK: - Configure
extension ArtistProfileVC {
    private func configureNavigationBar() {
        navigationItem.title = "작가"
        navigationController?.additionalSafeAreaInsets.top = 8
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "BackBtn"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(popVC))
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func configureCV() {
        exhibitionListCV.dataSource = self
        exhibitionListCV.delegate = self
        exhibitionListCV.register(UINib(nibName: Identifiers.exhibitionCVC, bundle: nil), forCellWithReuseIdentifier: Identifiers.exhibitionCVC)
        exhibitionListCV.showsVerticalScrollIndicator = false
        if let layout = exhibitionListCV.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = .zero
        }
    }
}

// MARK: - Network
extension ArtistProfileVC {
    private func getArtistProfile(artistID: Int) {
        LoadingHUD.show()
        MypageAPI.shared.getArtistProfile(artistID: artistID, completion: { [weak self] networkResult in
            guard let self = self else { return }
            switch networkResult {
            case .success(let data):
                if let data = data as? ArtistProfileModel {
                    self.artistData = data
                    self.configureCV()
                    LoadingHUD.hide()
                }
            case .requestErr(let res):
                if let message = res as? String {
                    print(message)
                    LoadingHUD.hide()
                    self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                } else if res is Bool {
                    self.requestRenewalToken() { _ in
                        self.getArtistProfile(artistID: artistID)
                    }
                }
            default:
                LoadingHUD.hide()
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        })
    }
}

// MARK: - UICollectionViewDataSource
extension ArtistProfileVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        artistData?.exhibition?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.exhibitionCVC, for: indexPath) as? ExhibitionCVC else { return UICollectionViewCell() }
        cell.configureCell(artistData?.exhibition?[indexPath.row] ?? ExhibitionModel())
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Identifiers.artistProfileHeaderView, for: indexPath) as? ArtistProfileHeaderView,
                  let artist = artistData?.user else { return UICollectionReusableView() }
            headerView.configureArtistData(artist: artist)
            return headerView
        default:
            return UICollectionReusableView()
        }
    }
}

// MARK: - UICollectionViewDelegate
extension ArtistProfileVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ExhibitionCVC,
              let detailVC = UIStoryboard(name: Identifiers.detailSB, bundle: nil).instantiateViewController(withIdentifier: Identifiers.detailVC) as? DetailVC else { return }
        detailVC.naviType = .push
        detailVC.exhibitionID = cell.exhibitionData?.exhibitionId
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ArtistProfileVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let widthPadding: CGFloat = 15
        
        let cellWidth = (width - widthPadding) / 2
        let cellHeight = 4 * cellWidth / 3 + 64
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        minimumLineSpacing
    }
}
