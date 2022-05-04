//
//  ExhibitionExplainView.swift
//  ARtique
//
//  Created by 황윤경 on 2022/03/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ExhibitionExplainView: UIView {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var categoryCV: UICollectionView!
    @IBOutlet weak var phosterChangeBtn: UIButton!
    @IBOutlet weak var phosterCV: UICollectionView!
    @IBOutlet weak var exhibitionExplainTextCnt: UILabel!
    @IBOutlet weak var exhibitionExplainTextView: UITextView!
    @IBOutlet weak var tagCV: UICollectionView!
    @IBOutlet weak var isPublic: UISwitch!
    
    let bag = DisposeBag()
    let exhibitionModel = NewExhibition.shared
    let exhibitionExplainPlaceholder = "전시회에 대한 전체 설명을 입력하세요"
    let tagMaxSelectionCnt = 3
    let textViewMaxCnt = 100
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setContentView()
        configureView()
        bindUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setContentView()
        configureView()
        bindUI()
    }
}

// MARK: - Configure
extension ExhibitionExplainView {
    private func setContentView() {
        guard let view = loadXibView(with: Identifiers.exhibitionExplainView) else { return }
        view.backgroundColor = .clear
        self.addSubview(view)
        
        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configureView() {
        scrollView.showsVerticalScrollIndicator = false
        
        titleTextField.setRoundTextField(with: "전시회의 제목을 입력하세요")
        
        categoryCV.isScrollEnabled = false
        configureCV(categoryCV, Identifiers.roundCVC)
        configureCV(phosterCV, Identifiers.phosterCVC)
        phosterCV.showsHorizontalScrollIndicator = false
        if let layout = phosterCV.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        exhibitionExplainTextView.setRoundTextView()
        exhibitionExplainTextView.setTextViewPlaceholder(exhibitionExplainPlaceholder)
        exhibitionExplainTextView.delegate = self
        
        tagCV.register(UINib(nibName: Identifiers.roundCVC, bundle: nil), forCellWithReuseIdentifier: Identifiers.roundCVC)
        tagCV.allowsMultipleSelection = true
        tagCV.dataSource = self
        tagCV.delegate = self
        
        isPublic.onTintColor = .black
        
        phosterChangeBtn.tintColor = .black
        phosterChangeBtn.setTitle("  대표사진 변경하기", for: .normal)
        phosterChangeBtn.titleLabel?.font = .AppleSDGothicSB(size: 12)
        phosterChangeBtn.setImage(UIImage(named: "Change"), for: .normal)
    }
    
    private func bindUI() {
        titleTextField.rx.text.orEmpty
            .withUnretained(self)
            .subscribe(onNext: { owner, title in
                owner.exhibitionModel.title = title
            })
            .disposed(by: bag)
        
        exhibitionExplainTextView.rx.text.orEmpty
            .withUnretained(self)
            .subscribe(onNext: { owner, explain in
                owner.exhibitionModel.exhibitionExplain = explain
                owner.setTextViewMaxCnt(explain.count)
            })
            .disposed(by: bag)
        
        tagCV.rx.itemDeselected
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.exhibitionModel.tagId = owner.selectedTags()
            })
            .disposed(by: bag)
        
        isPublic.rx.isOn
            .withUnretained(self)
            .subscribe(onNext: { owner, status in
                owner.exhibitionModel.isPublic = status
            })
            .disposed(by: bag)
        
        didSelectItem(at: categoryCV)
        didSelectItem(at: phosterCV)
        didSelectItem(at: tagCV)
    }
}

// MARK: - Custom Method
extension ExhibitionExplainView {
    private func configureCV(_ collectionView: UICollectionView, _ identifiers: String) {
        collectionView.register(UINib(nibName: identifiers, bundle: nil),
                                  forCellWithReuseIdentifier: identifiers)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    private func didSelectItem(at collectionView: UICollectionView) {
        collectionView.rx.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, index in
                switch collectionView {
                case owner.categoryCV:
                    owner.exhibitionModel.categoryId = index.row
                case owner.phosterCV:
                    owner.exhibitionModel.phosterId = index.row
                case owner.tagCV:
                    owner.exhibitionModel.tagId = owner.selectedTags()
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
    
    private func setTextViewMaxCnt(_ cnt: Int) {
        if exhibitionExplainTextView.textColor != .gray2 {
            exhibitionExplainTextCnt.text = "(\(cnt)/\(textViewMaxCnt))"
        }
    }
}

// MARK: - UICollectionViewDataSource
extension ExhibitionExplainView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case categoryCV:
            return CategoryType.allCases.count
        case phosterCV:
            return CategoryType.allCases.count
        default:
            return 8
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let roundCell = categoryCV.dequeueReusableCell(withReuseIdentifier: Identifiers.roundCVC, for: indexPath) as? RoundCVC,
              let selectedImageCell = phosterCV.dequeueReusableCell(withReuseIdentifier: Identifiers.phosterCVC, for: indexPath) as? PhosterCVC,
              let tagCell = tagCV.dequeueReusableCell(withReuseIdentifier: Identifiers.roundCVC, for: indexPath) as? RoundCVC
        else { return UICollectionViewCell() }
                
        switch collectionView {
        case categoryCV:
            roundCell.configureCell(with: CategoryType.allCases[indexPath.row].categoryTitle)
            return roundCell
        case phosterCV:
            selectedImageCell.configureCell(with: NewExhibition.shared.selectedArtwork?.first ?? UIImage())
            selectedImageCell.image.contentMode = .scaleAspectFill
            return selectedImageCell
        default:
            tagCell.configureCell(with: TagType.allCases[indexPath.row].tagTitle)
            return tagCell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ExhibitionExplainView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case categoryCV:
            return CGSize(width: (collectionView.frame.width - 52) / 3,
                          height: 30)
        case phosterCV:
            return CGSize(width: 98,
                          height: collectionView.frame.height)
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
extension ExhibitionExplainView: UICollectionViewDelegate {
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
extension ExhibitionExplainView: UITextViewDelegate {
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
            exhibitionExplainTextCnt.text = "\(textViewMaxCnt)"
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let str = textView.text else { return true }
        let newLength = str.count + text.count - range.length
        return newLength <= textViewMaxCnt + 1
    }
}
