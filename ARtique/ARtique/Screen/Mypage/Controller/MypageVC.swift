//
//  MypageVC.swift
//  ARtique
//
//  Created by 황윤경 on 2022/04/09.
//

import UIKit

class MypageVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNaviBar()
    }
}

// MARK: - Configure
extension MypageVC {
    private func configureNaviBar() {
        navigationController?.additionalSafeAreaInsets.top = 8
        navigationController?.navigationBar.tintColor = .black
        
        navigationItem.title = "마이페이지"
        
        let rightBarBtn = UIBarButtonItem(image: UIImage(named: "Alarm"),
                                          style: .plain,
                                          target: self,
                                          action: #selector(didTapRightNaviBtn))
        navigationItem.rightBarButtonItem = rightBarBtn
    }
}

extension MypageVC {
    @objc func didTapRightNaviBtn() {
        // TODO: - Alarm View 구현
        print("Alarm View")
    }
}
