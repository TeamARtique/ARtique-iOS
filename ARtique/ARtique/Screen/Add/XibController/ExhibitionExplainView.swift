//
//  ExhibitionExplainView.swift
//  ARtique
//
//  Created by 황윤경 on 2022/03/25.
//

import UIKit

class ExhibitionExplainView: UIView {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var categoryCV: UICollectionView!
    @IBOutlet weak var phosterCV: UICollectionView!
    @IBOutlet weak var tagCV: UICollectionView!
    @IBOutlet weak var exhibitionExplainTextView: UITextView!
    
    let exhibitionExplainPlaceholder = "전시회에 대한 전체 설명을 입력하세요"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setContentView()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setContentView()
        configureView()
    }
    
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
        
        titleTextField.setRoundTextField(with: "제목을 입력하세요")
        
        configureCV(categoryCV, Identifiers.roundCVC)
        configureCV(phosterCV, Identifiers.selectedImageCVC)
        
        exhibitionExplainTextView.setRoundTextView(with: exhibitionExplainPlaceholder)
        exhibitionExplainTextView.delegate = self
        
        tagCV.register(UINib(nibName: Identifiers.roundCVC, bundle: nil), forCellWithReuseIdentifier: Identifiers.roundCVC)
        tagCV.dataSource = self
        tagCV.delegate = self
    }
    
    private func configureCV(_ collectionView: UICollectionView, _ identifiers: String) {
        collectionView.register(UINib(nibName: identifiers, bundle: nil),
                                  forCellWithReuseIdentifier: identifiers)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        collectionView.showsHorizontalScrollIndicator = false
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
    }
}

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
              let selectedImageCell = phosterCV.dequeueReusableCell(withReuseIdentifier: Identifiers.selectedImageCVC, for: indexPath) as? SelectedImageCVC
        else { return UICollectionViewCell() }
                
        switch collectionView {
        case categoryCV:
            roundCell.configureCell(with: "\(CategoryType.allCases[indexPath.row].categoryTitle)", categoryCV.frame.height)
            return roundCell
        case phosterCV:
            selectedImageCell.configureCell(with: UIImage(named: "Theme1")!)
            selectedImageCell.image.contentMode = .scaleAspectFill
            return selectedImageCell
        default:
            roundCell.configureCell(with: "TAG", 30)
            return roundCell
        }
    }
}

extension ExhibitionExplainView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case categoryCV:
            return CGSize(width: 75,
                          height: collectionView.frame.height)
        case phosterCV:
            return CGSize(width: 98,
                          height: collectionView.frame.height)
        default:
            return CGSize(width: (collectionView.frame.width - 24) / 4,
                          height: 30)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case tagCV:
            return 8
        default:
            return 6
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        7
    }
}

// MARK: - UITextViewDelegate
extension ExhibitionExplainView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.setTextViewPlaceholder(exhibitionExplainPlaceholder)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.setTextViewPlaceholder(exhibitionExplainPlaceholder)
        }
    }
}
