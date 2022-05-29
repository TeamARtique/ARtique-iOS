//
//  ExhibitionListVC.swift
//  ARtique
//
//  Created by 황윤경 on 2022/04/14.
//

import UIKit

class ExhibitionListVC: BaseVC {
    @IBOutlet weak var exhibitionListCV: UICollectionView!
    
    var exhibitionData: [ExhibitionModel]?
    var isRightBarBtnExist = false
    var categoryID: Int?
    var isOrderChanged = false
    var checkedOrder = 0
    let minimumLineSpacing: CGFloat = 25
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureCV()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isRightBarBtnExist { getExhibitionList(categoryID: categoryID ?? 0, sort: .recent) }
    }
}

// MARK: - Configure
extension ExhibitionListVC {
    private func configureNavigationBar() {
        navigationController?.additionalSafeAreaInsets.top = 8
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "BackBtn"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(popVC))
        navigationController?.navigationBar.tintColor = .black
        
        setRightBarBtn()
    }
    
    private func configureCV() {
        exhibitionListCV.dataSource = self
        exhibitionListCV.delegate = self
        exhibitionListCV.register(UINib(nibName: Identifiers.exhibitionCVC, bundle: nil), forCellWithReuseIdentifier: Identifiers.exhibitionCVC)
        exhibitionListCV.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        exhibitionListCV.showsVerticalScrollIndicator = false
        if let layout = exhibitionListCV.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = .zero
        }
    }
}

// MARK: - Custom Methods
extension ExhibitionListVC {
    func setNaviBarTitle(_ title: String) {
        navigationItem.title = title
    }
    
    func setRightBarBtn() {
        if isRightBarBtnExist {
            let buttonWidth = 75
            let buttonHeight = 29
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight))
            
            button.backgroundColor = .clear
            button.setTitle("최신순 ", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.setImage(UIImage(named: "Reorder"), for: .normal)
            button.titleLabel?.font = .AppleSDGothicB(size: 12)
            button.semanticContentAttribute = .forceRightToLeft
            button.addTarget(self, action: #selector(presentBottomSheet), for: .touchUpInside)
            
            let rightBarButtonItem = UIBarButtonItem(customView: button)
            rightBarButtonItem.customView?.layer.borderColor = UIColor.label.cgColor
            rightBarButtonItem.customView?.layer.borderWidth = 1
            rightBarButtonItem.customView?.layer.cornerRadius = CGFloat(buttonHeight / 2)
            navigationItem.rightBarButtonItem = rightBarButtonItem
        }
    }
    
    @objc func presentBottomSheet(){
        let reorderBottomSheet = ReorderBottomSheetVC()
        reorderBottomSheet.delegate = self
        reorderBottomSheet.checkedOrder = checkedOrder
        self.present(reorderBottomSheet, animated: true)
    }
}

// MARK: - Network
extension ExhibitionListVC {
    private func getExhibitionList(categoryID: Int, sort: ExhibitionSortType) {
        HomeAPI.shared.getAllExhibitionList(categoryID: categoryID, sort: sort.rawValue) { [weak self] networkResult in
            switch networkResult {
            case .success(let list):
                if let list = list as? [ExhibitionModel] {
                    self?.exhibitionData = list
                    self?.exhibitionListCV.reloadData()
                }
            case .requestErr(let res):
                self?.getExhibitionList(categoryID: categoryID, sort: sort)
                if let message = res as? String {
                    print(message)
                    self?.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                }
            default:
                self?.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension ExhibitionListVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        exhibitionData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.exhibitionCVC, for: indexPath) as? ExhibitionCVC else { return UICollectionViewCell() }
        cell.configureCell(exhibitionData?[indexPath.row] ?? ExhibitionModel())
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension ExhibitionListVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ExhibitionCVC,
              let detailVC = UIStoryboard(name: Identifiers.detailSB, bundle: nil).instantiateViewController(withIdentifier: Identifiers.detailVC) as? DetailVC else { return }
        detailVC.naviType = .push
        detailVC.exhibitionID = cell.exhibitionData?.exhibitionId
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ExhibitionListVC: UICollectionViewDelegateFlowLayout {
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

// MARK: - TVCellDelegate
extension ExhibitionListVC: TVCellDelegate {
    func selectedTVC(sortedBy index: Int) {
        let rightBarButton = self.navigationItem.rightBarButtonItem!
        let button = rightBarButton.customView as! UIButton
        
        if index == 0 {
            button.setTitle("최신순 ", for: .normal)
            getExhibitionList(categoryID: categoryID ?? 1, sort: .recent)
        } else {
            button.setTitle("인기순 ", for: .normal)
            getExhibitionList(categoryID: categoryID ?? 1, sort: .like)
        }
        
        exhibitionListCV.reloadData()
        exhibitionListCV.scrollToItem(at: [0,0], at: .top, animated: true)
        checkedOrder = index
    }
}
