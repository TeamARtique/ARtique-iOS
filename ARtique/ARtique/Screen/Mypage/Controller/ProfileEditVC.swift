//
//  ProfileEditVC.swift
//  ARtique
//
//  Created by 황윤경 on 2022/04/11.
//

import UIKit

class ProfileEditVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNaviBar()
    }
}

// MARK: - Configure
extension ProfileEditVC {
    private func configureNaviBar() {
        navigationItem.title = "프로필 수정"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "BackBtn"),
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(popVC))
        navigationController?.setRoundRightBarBtn(navigationItem: self.navigationItem,
                                                  title: "완료",
                                                  target: self,
                                                  action: #selector(bindRightBarButton))
    }
}

// MARK: - Custom Methods
extension ProfileEditVC {
    @objc func popVC() {
        // TODO: - Show alert
        navigationController?.popViewController(animated: true)
    }
    
    @objc func bindRightBarButton() {
        // TODO: - post server
        navigationController?.popViewController(animated: true)
    }
}
