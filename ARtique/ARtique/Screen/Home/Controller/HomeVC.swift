//
//  HomeVC.swift
//  ARtique
//
//  Created by 황지은 on 2021/11/29.
//

import UIKit
import Tabman
import Pageboy

class HomeVC: TabmanViewController {
    
    private var viewControllers: Array<UIViewController> = []
    @IBOutlet weak var categoryTB: UIView!
    
    // statusbar color
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.tintColor = .black
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNaviBar()
        setCategoryTB()
    }
}

//MARK: - Custom Method
extension HomeVC {
    /// setNaviBar - 네비게이션 바 Setting
    func setNaviBar(){
        // title logo
        let logo = UIImage(named: "Logo")
        let imageView = UIImageView(image: logo)
        
        // 좌측 간격
        let naviSpacer = UIBarButtonItem()
        naviSpacer.width = 17

        navigationItem.leftBarButtonItems = [naviSpacer, UIBarButtonItem(customView: imageView)]
   
//        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        // background color
//        let naviAppearance = UINavigationBarAppearance()
//        naviAppearance.configureWithOpaqueBackground()
//        naviAppearance.backgroundColor = .black
//
//        navigationController?.navigationBar.standardAppearance = naviAppearance
//        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance

        
        // Navigation Buttons Setting
        let searchImg = UIImage(named: "Search")
        let ticketImg = UIImage(named: "Ticket")
        let searchBtn = UIBarButtonItem(image: searchImg, style: .plain, target: nil, action: nil)
        let ticketBtn = UIBarButtonItem(image: ticketImg, style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItems = [ticketBtn, searchBtn]
        navigationController?.navigationBar.tintColor = .white
    }
    
    /// setCategoryTB - 상단 탭바 Setting
    func setCategoryTB(){
        let artVC = UIStoryboard.init(name: "ExhibitionList", bundle: nil).instantiateViewController(withIdentifier: "exhibitionListVC") as! ExhibitionListVC
        let illustVC = UIStoryboard.init(name: "ExhibitionList", bundle: nil).instantiateViewController(withIdentifier: "exhibitionListVC") as! ExhibitionListVC
        let dailyVC = UIStoryboard.init(name: "ExhibitionList", bundle: nil).instantiateViewController(withIdentifier: "exhibitionListVC") as! ExhibitionListVC
        let petVC = UIStoryboard.init(name: "ExhibitionList", bundle: nil).instantiateViewController(withIdentifier: "exhibitionListVC") as! ExhibitionListVC
        let fanVC = UIStoryboard.init(name: "ExhibitionList", bundle: nil).instantiateViewController(withIdentifier: "exhibitionListVC") as! ExhibitionListVC
            
        viewControllers.append(artVC)
        viewControllers.append(illustVC)
        viewControllers.append(dailyVC)
        viewControllers.append(petVC)
        viewControllers.append(fanVC)
        
        self.dataSource = self

        // Create bar
        let bar = TMBar.ButtonBar()
        bar.backgroundView.style = .flat(color: .black)
        bar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 32.0, bottom: 0.0, right: 32.0)
        bar.buttons.customize { (button) in
            button.tintColor = .white
            button.selectedTintColor = .white
//            button.selectedFont = UIFont(name: "System font", size: 5)
//            button.widthAnchor.constraint(equalToConstant: 90).isActive = true
        }
        
        // 인디케이터 조정
//        bar.indicator.widthAnchor.constraint(equalToConstant: 60).isActive = true
        bar.indicator.weight = .heavy
        bar.indicator.tintColor = .white
        bar.indicator.overscrollBehavior = .compress
        
        bar.layout.alignment = .centerDistributed
        bar.layout.contentMode = .intrinsic
//        bar.layout.interButtonSpacing = 6
        bar.layout.interButtonSpacing = 40
        bar.layout.transitionStyle = .snap
        
        // Add to view
        addBar(bar, dataSource: self, at: .custom(view: categoryTB, layout: nil))
    }
}

//MARK: Tabman
extension HomeVC: TMBarDataSource {
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        switch index {
        case 0:
            return TMBarItem(title: "현대미술")
        case 1:
            return TMBarItem(title: "일러스트")
        case 2:
            return TMBarItem(title: "일상")
        case 3:
            return TMBarItem(title: "반려동물")
        case 4:
            return TMBarItem(title: "팬문화")
        default:
            let title = "Page \(index)"
            return TMBarItem(title: title)
        }
    }
}
//MARK: PageboyViewControllerDataSource
extension HomeVC: PageboyViewControllerDataSource{
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
}
