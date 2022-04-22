//
//  SearchVC.swift
//  ARtique
//
//  Created by 황윤경 on 2022/04/16.
//

import UIKit
import RxSwift
import RxCocoa

class SearchVC: UIViewController {
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var latestCV: UICollectionView!
    @IBOutlet weak var searchBtn: UIButton!
    var latestData = BehaviorRelay<[String]>(value: ["우리 코코", "사랑스러운", "Photo", "사랑스러운", "Photo"])
    
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNaviBar()
        configureCV()
        configureSearchBtn()
        hideKeyboard()
    }
    
    @IBAction func showSearchResultView(_ sender: Any) {
        didTapSearchBtn(keyword: searchTextField.text ?? "")
    }
}

// MARK: - Configure
extension SearchVC {
    private func configureNaviBar() {
        navigationController?.additionalSafeAreaInsets.top = 8
        navigationItem.title = "검색"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "BackBtn"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(popVC))
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func configureCV() {
        latestCV.dataSource = self
        latestCV.delegate = self
        latestCV.showsVerticalScrollIndicator = false
        latestCV.collectionViewLayout = CollectionViewLeftAlignFlowLayout()
        latestCV.backgroundColor = .white
        
        latestData.asObservable()
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.latestCV.isHidden = self.latestData.value.isEmpty
            }
            .disposed(by: bag)
    }
    
    private func configureSearchBtn() {
        searchTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: {[weak self] _ in
                guard let self = self else { return }
                self.searchBtn.tintColor
                = self.searchTextField.text == ""
                ? .lightGray : .black
                self.searchBtn.isUserInteractionEnabled
                = self.searchTextField.text == ""
                ? false : true
            })
            .disposed(by: bag)
    }
}

// MARK: - Custom Methods
extension SearchVC {
    @objc func popVC() {
        navigationController?.popViewController(animated: true)
    }
    
    private func didTapSearchBtn(keyword: String) {
        guard let resultVC = UIStoryboard(name: Identifiers.searchResultSB, bundle: nil).instantiateViewController(withIdentifier: Identifiers.searchResultVC) as? SearchResultVC else { return }
        resultVC.keyword = keyword
        // TODO: - 검색 개수 서버 연결
        resultVC.searchCnt = latestData.value.count
        navigationController?.pushViewController(resultVC, animated: true)
    }
    
    @objc func deleteSearchList(sender : UIButton) {
        latestCV.deleteItems(at: [IndexPath.init(row: sender.tag, section: 0)])
        var items = latestData.value
        items.remove(at: sender.tag)
        latestData.accept(items)
    }
}

// MARK: - UICollectionViewDataSource
extension SearchVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return latestData.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = latestCV.dequeueReusableCell(withReuseIdentifier: Identifiers.latestSearchedCVC, for: indexPath) as? LatestSearchedCVC else { return UICollectionViewCell() }
        cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(deleteSearchList(sender:)), for: .touchUpInside)
        cell.configureCell(with: latestData.value[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SearchVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cell = latestCV.dequeueReusableCell(withReuseIdentifier: Identifiers.latestSearchedCVC, for: indexPath) as? LatestSearchedCVC else { return .zero }
        cell.keyword.text = latestData.value[indexPath.row]
        cell.keyword.sizeToFit()
        
        let cellWidth = cell.keyword.frame.width + 16 + 8 + 20 + 8
        return CGSize(width: cellWidth, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = latestCV.cellForItem(at: indexPath) as? LatestSearchedCVC else { return }
        
        didTapSearchBtn(keyword: cell.keyword.text ?? "")
    }
}
