//
//  ExhibitionExplainVC.swift
//  ARtique
//
//  Created by 황윤경 on 2022/03/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ExhibitionExplainVC: UIViewController {
    @IBOutlet weak var baseSV: UIScrollView!
    @IBOutlet weak var titleTextCnt: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var categoryCV: UICollectionView!
    @IBOutlet weak var posterChangeBtn: UIButton!
    @IBOutlet weak var posterCV: UICollectionView!
    @IBOutlet weak var exhibitionExplainTextCnt: UILabel!
    @IBOutlet weak var exhibitionExplainTextView: UITextView!
    @IBOutlet weak var tagCV: UICollectionView!
    @IBOutlet weak var isPublic: UISwitch!
    
    let bag = DisposeBag()
    let exhibitionModel = NewExhibition.shared
    let exhibitionExplainPlaceholder = "전시회에 대한 전체 설명을 입력하세요"
    let tagMaxSelectionCnt = 3
    let titleMaxCnt = 25
    let textViewMaxCnt = 100
    var posterBase: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        bindUI()
        bindNotificationCenter()
    }
}

// MARK: - Configure
extension ExhibitionExplainVC {
    private func configureView() {
        baseSV.showsVerticalScrollIndicator = false
        
        titleTextField.setRoundTextField(with: "전시회의 제목을 입력하세요")
        titleTextField.delegate = self
        
        configureCV()
        
        posterChangeBtn.tintColor = .black
        posterChangeBtn.setTitle("  대표사진 변경하기", for: .normal)
        posterChangeBtn.titleLabel?.font = .AppleSDGothicSB(size: 12)
        posterChangeBtn.setImage(UIImage(named: "Change"), for: .normal)
        posterChangeBtn.addTarget(self, action: #selector(showPosterSelectVC), for: .touchUpInside)
        
        exhibitionExplainTextView.setRoundTextView()
        exhibitionExplainTextView.setTextViewPlaceholder(exhibitionExplainPlaceholder)
        exhibitionExplainTextView.delegate = self
        exhibitionExplainTextView.isScrollEnabled = false
        exhibitionExplainTextView.textContainer.maximumNumberOfLines = 4
        
        isPublic.onTintColor = .black
    }
    
    @objc func showPosterSelectVC() {
        guard let posterSelectVC = UIStoryboard(name: Identifiers.posterSelectSB, bundle: nil).instantiateViewController(withIdentifier: Identifiers.posterSelectVC) as? PosterSelectVC else { return }
        posterSelectVC.delegate = self
        present(posterSelectVC, animated: true, completion: nil)
    }
    
    private func configureCV() {
        categoryCV.register(UINib(nibName: Identifiers.roundCVC, bundle: nil),
                            forCellWithReuseIdentifier: Identifiers.roundCVC)
        categoryCV.dataSource = self
        categoryCV.delegate = self
        categoryCV.isScrollEnabled = false
        
        posterCV.register(BorderCVC.self, forCellWithReuseIdentifier: Identifiers.borderCVC)
        posterCV.dataSource = self
        posterCV.delegate = self
        posterCV.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        posterCV.showsHorizontalScrollIndicator = false
        if let layout = posterCV.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        tagCV.register(UINib(nibName: Identifiers.roundCVC, bundle: nil), forCellWithReuseIdentifier: Identifiers.roundCVC)
        tagCV.dataSource = self
        tagCV.delegate = self
        tagCV.allowsMultipleSelection = true
    }
    
    private func bindUI() {
        titleTextField.rx.text.orEmpty
            .withUnretained(self)
            .subscribe(onNext: { owner, title in
                owner.exhibitionModel.title = title
                owner.setTitleMaxCnt(title.count)
            })
            .disposed(by: bag)
        
        exhibitionExplainTextView.rx.text.orEmpty
            .withUnretained(self)
            .subscribe(onNext: { owner, explain in
                owner.exhibitionModel.description = explain
                owner.setTextViewMaxCnt(explain.count)
            })
            .disposed(by: bag)
        
        tagCV.rx.itemDeselected
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.exhibitionModel.tag = owner.selectedTags()
            })
            .disposed(by: bag)
        
        isPublic.rx.isOn
            .withUnretained(self)
            .subscribe(onNext: { owner, status in
                owner.exhibitionModel.isPublic = status
            })
            .disposed(by: bag)
        
        didSelectItem(at: categoryCV)
        didSelectItem(at: posterCV)
        didSelectItem(at: tagCV)
    }
}

// MARK: - Custom Method
extension ExhibitionExplainVC {
    private func didSelectItem(at collectionView: UICollectionView) {
        collectionView.rx.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, index in
                switch collectionView {
                case owner.categoryCV:
                    owner.exhibitionModel.category = index.row + 1
                case owner.posterCV:
                    owner.exhibitionModel.posterTheme = index.row
                case owner.tagCV:
                    owner.exhibitionModel.tag = owner.selectedTags()
                default:
                    break
                }
            })
            .disposed(by: bag)
    }
    
    private func selectedTags() -> [Int] {
        var selectedIndexRow = [Int]()
        tagCV.indexPathsForSelectedItems?.forEach {
            selectedIndexRow.append($0.row)
        }
        return selectedIndexRow
    }
    
    private func setTitleMaxCnt(_ cnt: Int) {
        if titleTextField.textColor != .gray2 {
            titleTextCnt.text = "(\(cnt)/\(titleMaxCnt))"
        }
    }
    
    private func setTextViewMaxCnt(_ cnt: Int) {
        if exhibitionExplainTextView.textColor != .gray2 {
            exhibitionExplainTextCnt.text = "(\(cnt)/\(textViewMaxCnt))"
        }
    }
    
    private func bindNotificationCenter() {
        NotificationCenter.default.keyboardWillChangeFrame()
            .withUnretained(self)
            .subscribe(onNext: { owner, info in
                if self.exhibitionExplainTextView.isFirstResponder {
                    UIView.animate(withDuration: info.duration) {
                        self.baseSV.snp.remakeConstraints {
                            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(16)
                            $0.bottom.equalToSuperview().offset(-info.height)
                        }
                        self.view.layoutIfNeeded()
                    }
                    self.baseSV.scrollToOffset(offset: info.height, animated: true)
                }
            })
            .disposed(by: bag)
        
        NotificationCenter.default.keyboardWillHideObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, info in
                if self.exhibitionExplainTextView.isFirstResponder {
                    UIView.animate(withDuration: info.duration) {
                        self.baseSV.snp.remakeConstraints {
                            $0.bottom.equalToSuperview()
                        }
                        self.view.layoutIfNeeded()
                    }
                    self.baseSV.scrollToBottom(animated: true)
                }
            })
            .disposed(by: bag)
    }
}

// MARK: - SelectPoster Delegate
extension ExhibitionExplainVC: SelectPoster {
    func selectPoster(with image: UIImage) {
        posterBase = image
        posterCV.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension ExhibitionExplainVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case categoryCV:
            return CategoryType.allCases.count
        case posterCV:
            return PosterType.allCases.count
        default:
            return 8
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let roundCell = categoryCV.dequeueReusableCell(withReuseIdentifier: Identifiers.roundCVC, for: indexPath) as? RoundCVC,
              let posterCell = posterCV.dequeueReusableCell(withReuseIdentifier: Identifiers.borderCVC, for: indexPath) as? BorderCVC,
              let tagCell = tagCV.dequeueReusableCell(withReuseIdentifier: Identifiers.roundCVC, for: indexPath) as? RoundCVC
        else { return UICollectionViewCell() }
                
        switch collectionView {
        case categoryCV:
            roundCell.configureCell(with: CategoryType.allCases[indexPath.row].categoryTitle, fontSize: 14)
            return roundCell
        case posterCV:
            posterCell.configurePosterCell(image: (posterBase ?? exhibitionModel.artworks?.first?.image) ?? UIImage(),
                                             overlay: UIImage(named: "cellTemplate\(indexPath.row)") ?? UIImage(),
                                             borderWidth: 4)
            return posterCell
        default:
            tagCell.configureCell(with: TagType.allCases[indexPath.row].tagTitle, fontSize: 13)
            return tagCell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ExhibitionExplainVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case categoryCV:
            return CGSize(width: (collectionView.frame.width - 12) / 3,
                          height: 30)
        case posterCV:
            return CGSize(width: 99, height: 132)
        default:
            guard let cell = tagCV.dequeueReusableCell(withReuseIdentifier: Identifiers.roundCVC, for: indexPath) as? RoundCVC else { return .zero }
            cell.contentLabel.text = TagType.allCases[indexPath.row].tagTitle
            cell.contentLabel.sizeToFit()
            let space = collectionView.frame.width - 208 - 5 * 3
            let cellWidth = cell.contentLabel.frame.width + space / 4
            return CGSize(width: cellWidth, height: 30)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case tagCV:
            return 5
        default:
            return 6
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        7
    }
}

// MARK: - UICollectionViewDelegate
extension ExhibitionExplainVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if collectionView == tagCV
            && tagCV.indexPathsForSelectedItems!.count >= tagMaxSelectionCnt {
            return false
        } else {
            return true
        }
    }
}

// MARK: - UITextViewDelegate
extension ExhibitionExplainVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView.textColor == .gray2 else { return }
        textView.textColor = .label
        textView.text = ""
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.setTextViewPlaceholder(exhibitionExplainPlaceholder)
        }
        
        if textView.text.count > textViewMaxCnt {
            textView.text.removeLast()
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        let newLength = textView.text.count + text.count - range.length
        return newLength <= textViewMaxCnt + 1
    }
}

// MARK: - UITextFieldDelegate
extension ExhibitionExplainVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.becomeFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.text?.count ?? 0) > titleMaxCnt {
            textField.text?.removeLast()
            titleTextCnt.text = "(25/\(titleMaxCnt))"
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = (textField.text?.count ?? 0) + string.count - range.length
        return newLength <= titleMaxCnt + 1
    }
}
