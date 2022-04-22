//
//  MypageVC.swift
//  ARtique
//
//  Created by 황윤경 on 2022/04/09.
//

import UIKit

class MypageVC: UIViewController {
    @IBOutlet weak var baseSV: UIScrollView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var explanation: UILabel!
    @IBOutlet weak var snsUrl: UILabel!
    @IBOutlet weak var exhibitionTV: UITableView!
    @IBOutlet weak var exhibitionTVHeight: NSLayoutConstraint!
    @IBOutlet weak var registeredExhibitionCnt: UILabel!
    @IBOutlet weak var bookmarkExhibitionCnt: UILabel!
    
    // dummyData
    var registerData: [ExhibitionData] = [
        ExhibitionData("My Lovely Cat", "우주인", UIImage(named: "MyLovelyCat")!, 8, 6),
        ExhibitionData("Future Body", "cl0ud", UIImage(named: "Future_Body")!, 10, 2),
        ExhibitionData("The Cat", "asdf", UIImage(named: "theCat")!, 12, 10),
        ExhibitionData("AGITATO 고양이", "TATO", UIImage(named: "AGITATO")!, 5, 3),
        ExhibitionData("제주 고양이", "juJe", UIImage(named: "JejuCat")!, 20, 15),
        ExhibitionData("Cat and Flower", "caf", UIImage(named: "CatAndFlower")!, 13, 9)
    ]
    var bookmarkData:[ExhibitionData] = [
        ExhibitionData("This is the Sun", "Magdiel", UIImage(named: "ThisistheSun")!, 120, 56),
        ExhibitionData("SAISON 17/18", "is0n", UIImage(named: "SAISON")!, 112, 89),
        ExhibitionData("Love Love Love", "Lx3", UIImage(named: "LoveLoveLove")!, 212, 101),
        ExhibitionData("PhotoClub", "toPho", UIImage(named: "PhotoClub")!, 95, 73),
        ExhibitionData("APOLLO", "StrongArm", UIImage(named: "APOLLO")!, 220, 115),
        ExhibitionData("우리 코코", "plataa", UIImage(named: "coco_phoster")!, 312, 198)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNaviBar()
        configureSV()
        configureProfile()
        configureTV()
    }
    
    @IBAction func pushEditView(_ sender: Any) {
        guard let profileEditVC = UIStoryboard(name: Identifiers.profileEditSB, bundle: nil).instantiateViewController(withIdentifier: Identifiers.profileEditVC) as? ProfileEditVC else { return }
        profileEditVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(profileEditVC, animated: true)
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
    
    private func configureSV() {
        baseSV.showsVerticalScrollIndicator = false
    }
    
    private func configureProfile() {
        profileImg.layer.cornerRadius = profileImg.frame.height / 2
        nickname.font = .AppleSDGothicR(size: 17)
        explanation.font = .AppleSDGothicR(size: 12)
        snsUrl.font = .AppleSDGothicR(size: 12)
    }
    
    private func configureTV() {
        exhibitionTV.dataSource = self
        exhibitionTV.delegate = self
        exhibitionTV.separatorStyle = .none
        exhibitionTV.isScrollEnabled = false
        exhibitionTV.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        
        if registerData.isEmpty && bookmarkData.isEmpty {
            exhibitionTV.isHidden = true
        } else if !registerData.isEmpty && !bookmarkData.isEmpty {
            exhibitionTVHeight.constant = 652
        } else {
            exhibitionTVHeight.constant = 326
        }
    }
}

// MARK: - Custom Methods
extension MypageVC {
    @objc func didTapRightNaviBtn() {
        // TODO: - Alarm View 구현
        print("Alarm View")
    }
}

// MARK: - UITableViewDataSource
extension MypageVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let titleCell = tableView.dequeueReusableCell(withIdentifier: Identifiers.mypageClassificationTVC, for: indexPath) as? MypageClassificationTVC,
              let exhibitionCell = tableView.dequeueReusableCell(withIdentifier: Identifiers.myExhibitionTVC, for: indexPath) as? MyExhibitionTVC else { return UITableViewCell() }
        titleCell.selectionStyle = .none
        switch indexPath.row {
        case 0:
            titleCell.configureCell("등록한 전시", 5)
            return titleCell
        case 1:
            // TODO: - 전시 연결
            exhibitionCell.exhibitionData = registerData
            return exhibitionCell
        case 2:
            titleCell.configureCell("북마크한 전시", 5)
            return titleCell
        case 3:
            // TODO: - 전시 연결
            exhibitionCell.exhibitionData = bookmarkData
            return exhibitionCell
        default:
            return UITableViewCell()
        }
    }
}

// MARK: - UITableViewDelegate
extension MypageVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        guard let cell = tableView.cellForRow(at: indexPath) as? MypageClassificationTVC else { return }
        guard let exhibitionListVC = ViewControllerFactory.viewController(for: .exhibitionList) as? ExhibitionListVC else { return }
        exhibitionListVC.hidesBottomBarWhenPushed = true
        exhibitionListVC.setNaviBarTitle((cell.exhibitionType.text ?? "") + " " + (cell.exhibitionCnt.text ?? ""))
        navigationController?.pushViewController(exhibitionListVC, animated: true)
    }
}
