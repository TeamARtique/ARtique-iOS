//
//  AddExhibitionVC.swift
//  ARtique
//
//  Created by 황윤경 on 2022/03/15.
//

import UIKit
import SnapKit

class AddExhibitionVC: UIViewController {
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var scrollView: UIScrollView!
    let themeView = ThemeView()
    
    var progress:Float = 0.2
    var page: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureRegisterProgressView()
        configureScrollView()
        configureStackView()
    }
}

// MARK: - Configure
extension AddExhibitionVC {
    func configureNavigationBar() {
        configureNavigationTitle(0)
        navigationController?.additionalSafeAreaInsets.top = 8
        navigationController?.setRoundRightBarBtn(navigationItem: self.navigationItem,
                                                    title: "다음",
                                                    target: self,
                                                    action: #selector(bindRightBarButton))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(bindLeftBarButton))
        navigationController?.navigationBar.tintColor = .black
    }
    
    func configureNavigationTitle(_ index: Int) {
        navigationItem.title = AddProcess.allCases[index].naviTitle
    }
    
    func configureNaviBarButton() {
        configurePrevButton()
        configureNextButton()
    }
    
    func configureNextButton() {
        let rightBarButton = self.navigationItem.rightBarButtonItem!
        let button = rightBarButton.customView as! UIButton
        
        (progressView.progress == 1)
        ? button.setTitle("등록하기", for: .normal)
        : button.setTitle("다음", for: .normal)
    }
    
    func configurePrevButton() {
        navigationItem.leftBarButtonItem?.image
        = (progressView.progress < 0.3)
        ? UIImage(systemName: "xmark")
        : UIImage(systemName: "chevron.backward")
    }
    
    func configureRegisterProgressView() {
        progressView.tintColor = .black
        progressView.progress = progress
    }
    
    // MARK: - Configure Content Page
    func configureScrollView() {
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSize(width: view.frame.width * 5,
                                        height: 0)
        scrollView.isScrollEnabled = false
    }
    
    func setScrollViewPaging(page: Int) {
        let page = page
        let width = scrollView.frame.width
        let targetX = CGFloat(page) * width
        
        var offset = scrollView.contentOffset
        offset.x = targetX
        
        scrollView.setContentOffset(offset, animated: true)
    }
    
    func configureStackView() {
        let views = [themeView]
        let stackView = UIStackView(arrangedSubviews: views)
        
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        
        configureLayout(themeView)
    }
    
    func configureLayout(_ view: UIView) {
        view.snp.makeConstraints {
            $0.width.equalTo(scrollView.snp.width)
            $0.height.equalTo(scrollView.snp.height)
        }
    }
}

// MARK: - Bind Button Action
extension AddExhibitionVC {
    @objc func bindRightBarButton() {
        if progressView.progress != 1 {
            progress += 0.2
            page += 1
            progressView.setProgress(progress, animated: true)
            configureNavigationTitle(page)
            configureNaviBarButton()
            setScrollViewPaging(page: page)
        } else {
            // TODO: - 게시글 등록 완료
        }
    }
    
    @objc func bindLeftBarButton() {
        if progressView.progress > 0.3 {
            progress -= 0.2
            page -= 1
            progressView.setProgress(progress, animated: true)
            configureNavigationTitle(page)
            configureNaviBarButton()
            setScrollViewPaging(page: page)
        } else {
            dismiss(animated: true)
        }
    }
}