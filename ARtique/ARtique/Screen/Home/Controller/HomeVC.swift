//
//  HomeVC.swift
//  ARtique
//
//  Created by 황지은 on 2021/11/29.
//

import UIKit
import Tabman
import Pageboy
import SnapKit

class HomeVC: TabmanViewController {
    @IBOutlet weak var customNavigationBar: UIView!
    @IBOutlet weak var categoryTB: UIView!
    @IBOutlet weak var categoryTBTopAnchor: NSLayoutConstraint!
    
    private let viewControllers: [HomeListVC] = CategoryType.allCases
        .compactMap { type in
            let vc = ViewControllerFactory.viewController(for: type.viewControllerType) as? HomeListVC
            vc?.categoryType = type
            return vc
        }
    
    private var categoryTypes: [CategoryType] {
        viewControllers.compactMap(\.categoryType)
    }
    
    public static var isNaviBarHidden: Bool = false
    
    // statusbar color
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.tintColor = .black
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCategoryPageDataSource()
        setCategoryIndicator()
        setNotification()
        presentSignUpVC()
    }
    
    @IBAction func showSearchView(_ sender: Any) {
        guard let searchVC = UIStoryboard(name: Identifiers.searchSB, bundle: nil).instantiateViewController(withIdentifier: Identifiers.searchVC) as? SearchVC else { return }
        searchVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    @IBAction func showTicketbookVC(_ sender: UIButton) {
        guard let ticketBookVC = UIStoryboard(name: Identifiers.ticketBookSB, bundle: nil).instantiateViewController(withIdentifier: TicketBookVC.className) as? TicketBookVC else { return }

        ticketBookVC.hidesBottomBarWhenPushed = true
        ticketBookVC.naviType = .push
        navigationController?.pushViewController(ticketBookVC, animated: true)
    }
}

//MARK: - Custom Method
extension HomeVC {
    func setCategoryPageDataSource() {
        self.dataSource = self
    }
    
    /// Category Bar Indicator Setting
    func setCategoryIndicator() {
        let bar = TMBar.ButtonBar()
        bar.backgroundView.style = .flat(color: .black)
        bar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 15.0)
        bar.buttons.customize { (button) in
            button.tintColor = .white
            button.selectedTintColor = .white
            
            button.font = UIFont.AppleSDGothicL(size: 16)
            button.selectedFont = UIFont.AppleSDGothicB(size: 16)
            button.widthAnchor.constraint(equalToConstant: 90).isActive = true
        }
        
        // 인디케이터 조정
        bar.indicator.weight = .heavy
        bar.indicator.tintColor = .clear
        bar.indicator.overscrollBehavior = .compress
        
        bar.layout.alignment = .centerDistributed
        bar.layout.contentMode = .intrinsic
        bar.layout.interButtonSpacing = 6
        bar.layout.transitionStyle = .snap
        
        let indicatorView = UIView()
        indicatorView.backgroundColor = .white
        indicatorView.layer.cornerRadius = 3
        indicatorView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bar.indicator.addSubview(indicatorView)
        indicatorView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
        }
        
        // Add to view
        addBar(bar, dataSource: self, at: .custom(view: categoryTB, layout: nil))
    }
    
    func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(upCategoryTabBar), name: .whenExhibitionListTVScrolledUp, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(downCategoryTabBar), name: .whenExhibitionListTVScrolledDown, object: nil)
    }
    
    @objc func upCategoryTabBar() {
        HomeVC.isNaviBarHidden = true
        
        self.customNavigationBar.layer.opacity = 0
        self.categoryTBTopAnchor.constant = 0
        self.view.layoutIfNeeded()
    }
    
    @objc func downCategoryTabBar() {
        HomeVC.isNaviBarHidden = false
        
        self.customNavigationBar.layer.opacity = 1
        self.categoryTBTopAnchor.constant = 68
        self.view.layoutIfNeeded()
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

//MARK: Tabman
extension HomeVC: TMBarDataSource {
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        TMBarItem(title: categoryTypes[index].categoryTitle)
    }
}

//MARK: PageboyViewControllerDataSource
extension HomeVC: PageboyViewControllerDataSource {
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
