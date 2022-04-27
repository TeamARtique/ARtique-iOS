//
//  NoneExhibitionVC.swift
//  ARtique
//
//  Created by 황윤경 on 2022/04/23.
//

import UIKit

class NoneExhibitionVC: UIViewController {
    @IBOutlet weak var addExhibitionBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureBtn()
    }
    
    @IBAction func pushAddTab(_ sender: Any) {
        let addExhibitionVC = ViewControllerFactory.viewController(for: .add)
        addExhibitionVC.modalPresentationStyle = .fullScreen
        present(addExhibitionVC, animated: true, completion: popVC)
    }
}

// MARK: - Configure
extension NoneExhibitionVC {
    private func configureNavigationBar() {
        navigationController?.additionalSafeAreaInsets.top = 8
        navigationItem.title = "등록한 전시 0"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "BackBtn"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(popVC))
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func configureBtn() {
        addExhibitionBtn.layer.cornerRadius = addExhibitionBtn.frame.height / 2
        addExhibitionBtn.backgroundColor = .black
        addExhibitionBtn.tintColor = .white
        addExhibitionBtn.titleLabel?.font = .AppleSDGothicB(size: 16)
    }
}

// MARK: - Custom Methods
extension NoneExhibitionVC {
    @objc func popVC() {
        navigationController?.popToRootViewController(animated: true)
    }
}
