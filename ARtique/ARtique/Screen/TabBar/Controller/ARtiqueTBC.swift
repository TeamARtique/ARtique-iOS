//
//  ARtiqueTBC.swift
//  ARtique
//
//  Created by 황지은 on 2021/11/29.
//

import UIKit
import Photos

class ARtiqueTBC: UITabBarController {
    
    // MARK: Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        setTabBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        presentSignUpVC()
    }
    
    //MARK: - Custom Method
    /// makeTabVC - 탭별 아이템 생성하는 함수
    func makeTabVC(vcType: TypeOfViewController?, tabBarTitle: String, tabBarImage: String, tabBarSelectedImage: String) -> UIViewController {
        let tab = vcType != nil ? ViewControllerFactory.viewController(for: vcType!) : UIViewController()
        tab.tabBarItem = UITabBarItem(title: tabBarTitle, image: UIImage(named: tabBarImage), selectedImage: UIImage(named: tabBarSelectedImage))
        return tab
    }
    
    /// setTabBar - 탭바 Setting
    func setTabBar() {
        let homeTab = makeTabVC(vcType: .home, tabBarTitle: "", tabBarImage: "untab_home", tabBarSelectedImage: "tab_home")
        let addTab = makeTabVC(vcType: nil, tabBarTitle: "", tabBarImage: "Add_Default", tabBarSelectedImage: "Add_Default")
        let mypageTab = makeTabVC(vcType: .mypage, tabBarTitle: "", tabBarImage: "My_UnSelected", tabBarSelectedImage: "My_Selected")
        
        homeTab.tabBarItem.imageInsets = UIEdgeInsets(top: -0.5, left: -0.5, bottom: -0.5, right: -35)
        addTab.tabBarItem.imageInsets = UIEdgeInsets(top: -10, left: -0.5, bottom: -0.5, right: -0.5)
        mypageTab.tabBarItem.imageInsets = UIEdgeInsets(top: -0.5, left: -35, bottom: -0.5, right: -0.5)
        
        // 탭바 스타일 설정
        tabBar.frame.size.height = 78
        tabBar.tintColor = .black
        tabBar.unselectedItemTintColor = .black
        
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabBar.layer.shadowRadius = 2
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.3
        
        tabBar.backgroundColor = .white
        tabBar.isTranslucent = false
        
        // 탭 구성
        let tabs =  [homeTab, addTab, mypageTab]
        
        // VC에 루트로 설정
        self.setViewControllers(tabs, animated: false)
    }
    
    /// openGallerySetting - 갤러리 접근 권한이 없을때 요청 alert을 띄우는 함수
    func openGallerySetting() {
        let alert = UIAlertController(title: "'ARtique'이(가) 갤러리 접근이 허용되어 있지 않습니다",
                                      message: "전시 등록을 위해\n갤러리 접근 권한을 설정해주세요",
                                      preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "취소", style: .default, handler: nil)
        let confirm = UIAlertAction(title: "설정", style: .default) { _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }
        
        alert.addAction(cancel)
        alert.addAction(confirm)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    /// 회원가입 추가 절차가 마무리되지 않았을 때 회원가입 VC를 띄우는 함수
    private func presentSignUpVC() {
        if UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) == "" {
            guard let signupVC = UIStoryboard(name: Identifiers.signupSB, bundle: nil).instantiateViewController(withIdentifier: SignupVC.className) as? SignupVC else { return }
            
            signupVC.hidesBottomBarWhenPushed = true
            signupVC.isFirstView = true
            
            let navi = UINavigationController(rootViewController: signupVC)
            navi.modalPresentationStyle = .fullScreen
            self.present(navi, animated: true)
        }
    }
}

// MARK: - UITabBarControllerDelegate
extension ARtiqueTBC: UITabBarControllerDelegate {
    
    /// shouldSelect
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let addVC = viewControllers![1]
        
        if viewController == addVC {
            PHPhotoLibrary.requestAuthorization( { status in
                switch status{
                case .authorized:
                    DispatchQueue.main.async {
                        let addExhibitionVC = ViewControllerFactory.viewController(for: .add)
                        addExhibitionVC.modalPresentationStyle = .fullScreen
                        self.present(addExhibitionVC, animated: true, completion: nil)
                    }
                default:
                    DispatchQueue.main.async {
                        self.openGallerySetting()
                    }
                }
            })
            return false
        } else {
            return true
        }
    }
}
