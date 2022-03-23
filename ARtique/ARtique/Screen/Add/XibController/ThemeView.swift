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
        guard let view = loadXibView(with: Identifiers.themeView) else { return }
        view.backgroundColor = .clear
        self.addSubview(view)
        
        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configureCV() {
        cntCV.dataSource = self
        cntCV.delegate = self
        cntCV.register(UINib(nibName: Identifiers.roundCVC, bundle: nil),
                       forCellWithReuseIdentifier: Identifiers.roundCVC)
        
        themeCV.dataSource = self
        themeCV.delegate = self
        themeCV.register(UINib(nibName: Identifiers.themeCVC, bundle: nil), forCellWithReuseIdentifier: Identifiers.themeCVC)
    }
    
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
            roundCell.configureCell(with: setGalleryCount(indexPath.row))
            return roundCell
        case themeCV:
            themeCell.configureCell(image: UIImage(named: "Theme\(indexPath.row + 1)")!,
                                    title: "테마 \(indexPath.row + 1)")
            return themeCell
        default:
            return UICollectionViewCell()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ThemeView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case cntCV:
            return 13
        default:
            return 16
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case cntCV:
            return CGSize(width: (collectionView.frame.width - 26) / 3,
                          height: collectionView.frame.height)
        default:
            let cellWidth = (collectionView.frame.width - 16) / 2
            return CGSize(width: cellWidth,
                          height: cellWidth + 23)
        }
    }
}
