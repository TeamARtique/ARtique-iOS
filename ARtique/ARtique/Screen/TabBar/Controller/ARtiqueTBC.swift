//
//  ARtiqueTBC.swift
//  ARtique
//
//  Created by 황지은 on 2021/11/29.
//

import UIKit

class ARtiqueTBC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        setTabBar()
    }
    
    //MARK: - Custom Method
    /// makeTabVC - 탭별 아이템 생성하는 함수
    func makeTabVC(vcType: TypeOfViewController, tabBarTitle: String, tabBarImage: String, tabBarSelectedImage: String) -> UIViewController {
        
        let tab = ViewControllerFactory.viewController(for: vcType)
        tab.tabBarItem = UITabBarItem(title: tabBarTitle, image: UIImage(named: tabBarImage), selectedImage: UIImage(named: tabBarSelectedImage))
        return tab
    }
    
    /// setTabBar - 탭바 Setting
    func setTabBar() {
        
        let homeTab = makeTabVC(vcType: .home, tabBarTitle: "", tabBarImage: "Home_UnSelected", tabBarSelectedImage: "Home_Selected")
        let addTab = makeTabVC(vcType: .add, tabBarTitle: "", tabBarImage: "Add_Default_", tabBarSelectedImage: "Add_Default_")
        let mypageTab = makeTabVC(vcType: .mypage, tabBarTitle: "", tabBarImage: "My_UnSelected", tabBarSelectedImage: "My_Selected")
        
        homeTab.tabBarItem.imageInsets = UIEdgeInsets(top: -0.5, left: -0.5, bottom: -0.5, right: -35)
        addTab.tabBarItem.imageInsets = UIEdgeInsets(top: -40, left: -0.5, bottom: -0.5, right: -0.5)
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
}

extension ARtiqueTBC: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let addVC = viewControllers![1]
        
        if viewController == addVC {
            let addExhibitionVC = ViewControllerFactory.viewController(for: .add)
            addExhibitionVC.modalPresentationStyle = .fullScreen
            present(addExhibitionVC, animated: true, completion: nil)
            return false
        } else {
            return true
        }
    }
}
