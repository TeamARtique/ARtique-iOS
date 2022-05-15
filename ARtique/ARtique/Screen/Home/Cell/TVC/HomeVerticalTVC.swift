//
//  AllTVC.swift
//  ARtique
//
//  Created by 황윤경 on 2021/12/05.
//

import UIKit

class HomeVerticalTVC: UITableViewCell{
    var allData: [ExhibitionModel]?

    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var showAllListBtn: UIButton!
    @IBOutlet weak var allExhibitionCV: UICollectionView!
    
    // TVC cell 구분용
    var cellIdentifier = 0
    var delegate: CVCellDelegate?
    let minimumLineSpacing: CGFloat = 25
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpDelegate()
        setUpAllTVCView()
        setAllExhibitionCV()
    }
    
    @IBAction func showAllExhibitionList(_ sender: Any) {
        let title = subTitle.text?.split(separator: " ")
        NotificationCenter.default.post(name: .whenAllExhibitionBtnSelected, object: "\(title?[0] ?? "")")
    }
}

//MARK: - Custom Method
extension HomeVerticalTVC {
    func setUpDelegate() {
        allExhibitionCV.delegate = self
        allExhibitionCV.dataSource = self
    }
    
    func setUpAllTVCView() {
        showAllListBtn.backgroundColor = .black
        showAllListBtn.layer.cornerRadius = showAllListBtn.frame.height / 2
        
        showAllListBtn.setTitle("전체보기", for: .normal)
        showAllListBtn.titleLabel?.font = UIFont.AppleSDGothicB(size: 12)
        showAllListBtn.tintColor = .white
    }
    
    func setAllExhibitionCV() {
        allExhibitionCV.isScrollEnabled = false
        allExhibitionCV.register(UINib(nibName: Identifiers.exhibitionCVC, bundle: nil), forCellWithReuseIdentifier: Identifiers.exhibitionCVC)
    }
}

// MARK: UICollectionViewDataSource
extension HomeVerticalTVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.exhibitionCVC, for: indexPath) as? ExhibitionCVC else { return UICollectionViewCell() }
        cell.configureCell(allData?[indexPath.row] ?? ExhibitionModel())
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension HomeVerticalTVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 화면 전환
        if let delegate = delegate {
            delegate.selectedCVC(indexPath, cellIdentifier, collectionView)
        }
    }
}
// MARK: UICollectionViewDelegateFlowLayout
extension HomeVerticalTVC: UICollectionViewDelegateFlowLayout {
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
