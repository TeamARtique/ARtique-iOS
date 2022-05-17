//
//  ThemeView.swift
//  ARtique
//
//  Created by 황윤경 on 2022/03/16.
//

import UIKit
import SnapKit

class ThemeView: UIView {
    @IBOutlet weak var cntCV: UICollectionView!
    @IBOutlet weak var themeCV: UICollectionView!
    let exhibitionModel = NewExhibition.shared
    
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
}

// MARK: - Configure
extension ThemeView {
    private func setContentView() {
        guard let view = loadXibView(with: Identifiers.themeView) else { return }
        view.backgroundColor = .clear
        self.addSubview(view)
        
        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configureCV() {
        cntCV.dataSource = self
        cntCV.delegate = self
        cntCV.register(UINib(nibName: Identifiers.roundCVC, bundle: nil),
                       forCellWithReuseIdentifier: Identifiers.roundCVC)
        
        themeCV.dataSource = self
        themeCV.delegate = self
        themeCV.register(UINib(nibName: Identifiers.themeCVC, bundle: nil), forCellWithReuseIdentifier: Identifiers.themeCVC)
        themeCV.isScrollEnabled = false
    }
}

// MARK: - Custom Methods
extension ThemeView {
    func setGalleryCount(_ index: Int) -> Int {
        switch index {
        case 0:
            return 5
        case 1:
            return 12
        case 2:
            return 30
        default:
            return 0
        }
    }
}

// MARK: - UICollectionViewDataSource
extension ThemeView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case cntCV:
            return 3
        default:
            return 4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let roundCell = cntCV.dequeueReusableCell(withReuseIdentifier: Identifiers.roundCVC, for: indexPath) as? RoundCVC,
              let themeCell = themeCV.dequeueReusableCell(withReuseIdentifier: Identifiers.themeCVC, for: indexPath) as? ThemeCVC else {
                  return UICollectionViewCell()
              }
        
        switch collectionView {
        case cntCV:
            roundCell.configureCell(with: "\(setGalleryCount(indexPath.row))개", fontSize: 15)
            return roundCell
        case themeCV:
            themeCell.configureCell(image: ThemeType.init(rawValue: indexPath.row + 1)?.themeImage ?? UIImage(),
                                    title: ThemeType.init(rawValue: indexPath.row + 1)?.themeTitle ?? "")
            return themeCell
        default:
            return UICollectionViewCell()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ThemeView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case cntCV:
            return 13
        default:
            return 15
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case cntCV:
            return CGSize(width: (UIScreen.main.bounds.width - 40 - 26) / 3,
                          height: collectionView.frame.height)
        default:
            let cellWidth = (collectionView.frame.width - 15) / 2
            return CGSize(width: cellWidth,
                          height: cellWidth + 23)
        }
    }
}

extension ThemeView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case cntCV:
            exhibitionModel.gallerySize = setGalleryCount(indexPath.row)
            exhibitionModel.artworks = [ArtworkData](repeating: ArtworkData(), count: exhibitionModel.gallerySize!)
        default:
            exhibitionModel.galleryTheme = indexPath.row
        }
    }
}
