//
//  AddExhibitionVC.swift
//  ARtique
//
//  Created by 황윤경 on 2022/03/15.
//

import UIKit

class AddExhibitionVC: UIViewController {
    @IBOutlet weak var progressView: UIProgressView!
    let scrollView = UIScrollView()
    
    var progress:Float = 0.2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureRegisterProgressView()
    }
}

// MARK: - Configure
extension AddExhibitionVC {
    func configureNavigationBar() {
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
}

// MARK: - Bind Button Action
extension AddExhibitionVC {
    @objc func bindRightBarButton() {
        if progressView.progress != 1 {
            progress += 0.2
            progressView.setProgress(progress, animated: true)
            configureNaviBarButton()
        }
    }
    
    @objc func bindLeftBarButton() {
        if progressView.progress > 0.3 {
            progress -= 0.2
            progressView.setProgress(progress, animated: true)
            configureNaviBarButton()
        } else {
            dismiss(animated: true)
        }
    }
}
