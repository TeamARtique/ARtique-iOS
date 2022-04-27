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
    @IBOutlet weak var registeredExhibitionBtn: ExhibitionCntBtn!
    @IBOutlet weak var ticketBtn: ExhibitionCntBtn!
    
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
    var ticketCnt: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNaviBar()
        configureSV()
        configureProfile()
        configureExhibitionCntBtn()
        configureTV()
    }
    
    @IBAction func pushEditView(_ sender: Any) {
        guard let profileEditVC = UIStoryboard(name: Identifiers.profileEditSB, bundle: nil).instantiateViewController(withIdentifier: Identifiers.profileEditVC) as? ProfileEditVC else { return }
        profileEditVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(profileEditVC, animated: true)
    }
    
    @IBAction func showRegisteredExhibition(_ sender: Any) {
        if !registerData.isEmpty {
            showExhibitionListVC(title: "등록한 전시 \(registerData.count)", data: registerData)
        } else {
            guard let noneExhibitionVC = UIStoryboard(name: Identifiers.noneExhibitionSB, bundle: nil).instantiateViewController(withIdentifier: Identifiers.noneExhibitionVC) as? NoneExhibitionVC else { return }
            noneExhibitionVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(noneExhibitionVC, animated: true)
        }
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
    
    private func configureExhibitionCntBtn() {
        registeredExhibitionBtn.title.text = "등록 전시 수"
        registeredExhibitionBtn.exhibitionCnt.text = "\(registerData.count)"
        
        ticketBtn.title.text = "내 티켓 수"
        ticketBtn.exhibitionCnt.text = "\(ticketCnt ?? 0)"
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
    
    private func showExhibitionListVC(title: String, data: [ExhibitionData]) {
        guard let exhibitionListVC = ViewControllerFactory.viewController(for: .exhibitionList) as? ExhibitionListVC else { return }
        exhibitionListVC.hidesBottomBarWhenPushed = true
        exhibitionListVC.exhibitionData = data
        exhibitionListVC.setNaviBarTitle(title)
        navigationController?.pushViewController(exhibitionListVC, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension MypageVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        !registerData.isEmpty && !bookmarkData.isEmpty ? 4 : 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let titleCell = tableView.dequeueReusableCell(withIdentifier: Identifiers.mypageClassificationTVC, for: indexPath) as? MypageClassificationTVC,
              let exhibitionCell = tableView.dequeueReusableCell(withIdentifier: Identifiers.myExhibitionTVC, for: indexPath) as? MyExhibitionTVC else { return UITableViewCell() }
        titleCell.selectionStyle = .none
        exhibitionCell.delegate = self
        
        switch indexPath.row {
        case 0:
            !registerData.isEmpty
            ? titleCell.configureCell("등록한 전시", registerData.count)
            : titleCell.configureCell("북마크한 전시", bookmarkData.count)
            return titleCell
        case 1:
            exhibitionCell.exhibitionData = !registerData.isEmpty
            ? registerData : bookmarkData
            return exhibitionCell
        case 2:
            titleCell.configureCell("북마크한 전시", bookmarkData.count)
            return titleCell
        case 3:
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
        guard let cell = tableView.cellForRow(at: indexPath) as? MypageClassificationTVC else { return }
        
        switch cell.exhibitionType.text {
        case "등록한 전시":
            showExhibitionListVC(title: "등록한 전시 \(registerData.count)", data: registerData)
        case "북마크한 전시":
            showExhibitionListVC(title: "북마크한 전시 \(bookmarkData.count)", data: bookmarkData)
        default:
            break
        }
    }
}

// MARK: - CVCellDelegate
extension MypageVC: CVCellDelegate {
    func selectedCVC(_ index: IndexPath, _ cellIdentifier: Int, _ collectionView: UICollectionView) {
        guard let detailVC = UIStoryboard(name: Identifiers.detailSB, bundle: nil).instantiateViewController(withIdentifier: Identifiers.detailVC) as? DetailVC,
              let cell = collectionView.cellForItem(at: index) as? ExhibitionCVC else { return }
        detailVC.exhibitionData = cell.exhibitionData
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
