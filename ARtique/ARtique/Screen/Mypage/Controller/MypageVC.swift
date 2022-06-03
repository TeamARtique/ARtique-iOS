//
//  MypageVC.swift
//  ARtique
//
//  Created by 황윤경 on 2022/04/09.
//

import UIKit
import Kingfisher

class MypageVC: BaseVC {
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
    
    var artistData: ArtistProfile?
    var registerData: [ExhibitionModel]?
    var bookmarkData: [ExhibitionModel]?
    var ticketCnt: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNaviBar()
        configureSV()
        configureProfile()
        configureExhibitionCntBtn()
        configureTV()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getMypageData()
    }
    
    @IBAction func pushEditView(_ sender: Any) {
        guard let profileEditVC = UIStoryboard(name: Identifiers.profileEditSB, bundle: nil).instantiateViewController(withIdentifier: Identifiers.profileEditVC) as? ProfileEditVC,
              let artistData = artistData else { return }
        profileEditVC.artistData = artistData
        profileEditVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(profileEditVC, animated: true)
    }
    
    @IBAction func showRegisteredExhibition(_ sender: Any) {
        if !(registerData?.isEmpty ?? true) {
            showExhibitionListVC(title: "등록한 전시 \(registerData?.count ?? 0)", data: registerData!)
        } else {
            guard let noneExhibitionVC = UIStoryboard(name: Identifiers.noneExhibitionSB, bundle: nil).instantiateViewController(withIdentifier: Identifiers.noneExhibitionVC) as? NoneExhibitionVC else { return }
            noneExhibitionVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(noneExhibitionVC, animated: true)
        }
    }
    
    @IBAction func showTicketBook(_ sender: Any) {
        let ticketbookVC = TicketBookVC()
        ticketbookVC.hidesBottomBarWhenPushed = true
        ticketbookVC.naviType = .push
        navigationController?.pushViewController(ticketbookVC, animated: true)
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
        let profileTapGesture = UITapGestureRecognizer(target: self, action: #selector(showProfile))
        profileImg.addGestureRecognizer(profileTapGesture)
        profileImg.isUserInteractionEnabled = true
        
        profileImg.layer.cornerRadius = profileImg.frame.height / 2
        nickname.font = .AppleSDGothicSB(size: 17)
        explanation.font = .AppleSDGothicR(size: 12)
        explanation.setLineBreakMode()
        snsUrl.font = .AppleSDGothicR(size: 12)
        snsUrl.setLineBreakMode()
    }
    
    private func configureExhibitionCntBtn() {
        registeredExhibitionBtn.title.text = "등록 전시 수"
        registeredExhibitionBtn.exhibitionCnt.text = "\(registerData?.count ?? 0)"
        
        ticketBtn.title.text = "내 티켓 수"
        ticketBtn.exhibitionCnt.text = "\(ticketCnt ?? 0)"
    }
    
    private func configureTV() {
        exhibitionTV.dataSource = self
        exhibitionTV.delegate = self
        exhibitionTV.separatorStyle = .none
        exhibitionTV.isScrollEnabled = false
        exhibitionTV.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        exhibitionTV.isHidden = true
    }
    
    private func setUserData(artist: ArtistProfile) {
        profileImg.kf.setImage(with: URL(string: artist.profileImage),
                               placeholder: UIImage(named: "DefaultProfile"),
                               options: [
                                .scaleFactor(UIScreen.main.scale),
                                .cacheOriginalImage
                               ])
        nickname.text = artist.nickname
        explanation.text = artist.introduction
        snsUrl.text = artist.website
    }
    
    private func setTVHidden(myData: MypageModel) {
        exhibitionTV.isHidden
        = myData.myExhibition.isEmpty && myData.myBookmarkedData.isEmpty
        ? true : false
        
        exhibitionTVHeight.constant
        = !myData.myExhibition.isEmpty && !myData.myBookmarkedData.isEmpty
        ? 652 : 326
    }
}

// MARK: - Custom Methods
extension MypageVC {
    @objc func didTapRightNaviBtn() {
        // TODO: - Alarm View 구현
        print("Alarm View")
    }
    
    private func showExhibitionListVC(title: String, data: [ExhibitionModel]) {
        guard let exhibitionListVC = ViewControllerFactory.viewController(for: .exhibitionList) as? ExhibitionListVC else { return }
        exhibitionListVC.hidesBottomBarWhenPushed = true
        exhibitionListVC.exhibitionData = data
        exhibitionListVC.setNaviBarTitle(title)
        navigationController?.pushViewController(exhibitionListVC, animated: true)
    }
    
    @objc func showProfile() {
        showProfileImage(with: profileImg.image ?? UIImage(named: "DefaultProfile")!)
    }
}

// MARK: - Network
extension MypageVC {
    private func getMypageData() {
        LoadingHUD.show()
        MypageAPI.shared.getMypageData { [weak self] networkResult in
            guard let self = self else { return }
            switch networkResult {
            case .success(let data):
                if let data = data as? MypageModel {
                    self.registerData = data.myExhibition
                    self.bookmarkData = data.myBookmarkedData
                    self.ticketCnt = data.user.ticketCount
                    self.artistData = data.user
                    self.setUserData(artist: data.user)
                    self.configureExhibitionCntBtn()
                    self.setTVHidden(myData: data)
                    self.exhibitionTV.reloadData()
                    LoadingHUD.hide()
                }
            case .requestErr(let res):
                if let message = res as? String {
                    print(message)
                    LoadingHUD.hide()
                    self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                } else if res is Bool {
                    self.requestRenewalToken() { _ in
                        self.getMypageData()
                    }
                }
            default:
                LoadingHUD.hide()
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension MypageVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let isRegisterData = registerData?.isEmpty,
              let isBookmarkData = bookmarkData?.isEmpty else { return 0 }
        return !isRegisterData && !isBookmarkData ? 4 : 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let titleCell = tableView.dequeueReusableCell(withIdentifier: Identifiers.mypageClassificationTVC, for: indexPath) as? MypageClassificationTVC,
              let exhibitionCell = tableView.dequeueReusableCell(withIdentifier: Identifiers.myExhibitionTVC, for: indexPath) as? MyExhibitionTVC else { return UITableViewCell() }
        titleCell.selectionStyle = .none
        exhibitionCell.delegate = self
        
        switch indexPath.row {
        case 0:
            !(registerData?.isEmpty ?? true)
            ? titleCell.configureCell("등록한 전시", registerData?.count ?? 0)
            : titleCell.configureCell("북마크한 전시", bookmarkData?.count ?? 0)
            return titleCell
        case 1:
            exhibitionCell.exhibitionData = !(registerData?.isEmpty ?? true)
            ? registerData : bookmarkData
            return exhibitionCell
        case 2:
            titleCell.configureCell("북마크한 전시", bookmarkData?.count ?? 0)
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
            showExhibitionListVC(title: "등록한 전시 \(registerData?.count ?? 0)", data: registerData ?? [ExhibitionModel]())
        case "북마크한 전시":
            showExhibitionListVC(title: "북마크한 전시 \(bookmarkData?.count ?? 0)", data: bookmarkData ?? [ExhibitionModel]())
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
        detailVC.exhibitionID = cell.exhibitionData?.exhibitionId
        detailVC.naviType = .push
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
