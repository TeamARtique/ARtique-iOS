//
//  TicketBookVC.swift
//  ARtique
//
//  Created by hwangJi on 2022/05/18.
//

import UIKit
import SnapKit
import Then

class TicketBookVC: BaseVC {
    
    // MARK: Properties
    private let ticketCV = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 28
        layout.minimumInteritemSpacing = 16
        $0.collectionViewLayout = layout
        $0.backgroundColor = .white
        $0.contentInset = UIEdgeInsets.init(top: 24, left: 20, bottom: 0, right: 20)
        $0.showsVerticalScrollIndicator = false
    }
    
    private let lookAroundBtn = UIButton().then {
        $0.backgroundColor = .black
        $0.setTitle("ARtique 둘러보기", for: .normal)
        $0.titleLabel?.font = .AppleSDGothicB(size: 16.0)
        $0.titleLabel?.textColor = .white
        $0.layer.cornerRadius = 43 / 2
        $0.layer.masksToBounds = true
    }
    
    // MARK: Variables
    private var ticketData: [TicketListModel] = []
    var naviType: NaviType?
    private var isDeleteMode: Bool = false
    private var deleteIndex: Int?
    private var selectedIndexPath: IndexPath?
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNaviBar(naviType: naviType ?? .push)
        setUpDelegate()
        registerCell()
        configureUI()
        getTicketbookList()
        lookAroundBtnDidTap(naviType: naviType ?? .push)
        NotificationCenter.default.addObserver(self, selector: #selector(shareToInstagramStory(_:)), name: .whenTicketShareBtnDidTap, object: nil)
    }
}

// MARK: - UI
extension TicketBookVC {
    
    /// 네비게이션 바를 구성하는 메서드
    private func configureNaviBar(naviType: NaviType) {
        navigationController?.additionalSafeAreaInsets.top = 8
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.isTranslucent = true
        navigationItem.title = "티켓북"
        if isDeleteMode {
            navigationItem.rightBarButtonItem = navigationController?.roundFilledBarBtn(title: "완료",
                                                                                        target: self,
                                                                                        action: #selector(didTapTrashBtn))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "btn_delete"),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(didTapTrashBtn))
        }
        
        switch naviType {
        case .push:
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "BackBtn"),
                                                               style: .plain,
                                                               target: self,
                                                               action: #selector(popVC))
        case .dismissToRoot:
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "dismissBtn"),
                                                               style: .plain,
                                                               target: self,
                                                               action: #selector(homeToRoot))
            
        default:
            print("default")
        }
    }
    
    /// 전체 UI를 구성하는 메서드
    private func configureUI() {
        view.addSubviews([ticketCV, lookAroundBtn])
        ticketCV.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        lookAroundBtn.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(61)
            $0.leading.equalToSuperview().offset(23)
            $0.trailing.equalToSuperview().inset(23)
            $0.height.equalTo(43)
        }
    }
}

// MARK: - Custom Methods
extension TicketBookVC {
    
    /// 대리자 위임 메서드
    private func setUpDelegate() {
        ticketCV.delegate = self
        ticketCV.dataSource = self
    }
    
    /// 셀 등록 메서드
    private func registerCell() {
        ticketCV.register(TicketCVC.self, forCellWithReuseIdentifier: TicketCVC.className)
        ticketCV.register(TicketHeaderCVC.self, forCellWithReuseIdentifier: TicketHeaderCVC.className)
        ticketCV.register(EmptyCVC.self, forCellWithReuseIdentifier: EmptyCVC.className)
    }
    
    /// 티켓북 삭제 버튼을 클릭했을 때 실행되는 메서드
    @objc
    private func didTapTrashBtn() {
        Vibration.light.vibrate()
        isDeleteMode = !isDeleteMode
        configureNaviBar(naviType: naviType ?? .push)
        ticketCV.reloadData()
    }
    
    /// 티켓북 Cell을 이미지로 렌더링하여 인스타그램 스토리로 공유하는 메서드
    @objc
    private func shareToInstagramStory(_ notification: NSNotification) {
        var index: IndexPath = []
        if let indexPath = notification.userInfo?["indexPath"] as? IndexPath {
            index = indexPath
        }
        
        if let instagramStoryURL = URL(string: "instagram-stories://share") {
            if UIApplication.shared.canOpenURL(instagramStoryURL) {
                let cell = ticketCV.cellForItem(at: index)
                let renderer = UIGraphicsImageRenderer(size: cell?.layer.bounds.size ?? CGSize.zero)
                
                let renderImage = renderer.image { _ in
                    cell?.drawHierarchy(in: cell?.bounds ?? CGRect.zero, afterScreenUpdates: true)
                }
                
                guard let imageData = renderImage.pngData() else { return }
                
                let pasteboardItems : [String: Any] = [
                    "com.instagram.sharedSticker.stickerImage": imageData,
                    "com.instagram.sharedSticker.backgroundTopColor" : "#636e72",
                    "com.instagram.sharedSticker.backgroundBottomColor" : "#b2bec3",
                ]
                
                let pasteboardOptions = [
                    UIPasteboard.OptionsKey.expirationDate : Date().addingTimeInterval(300)
                ]
                
                UIPasteboard.general.setItems([pasteboardItems], options: pasteboardOptions)
                UIApplication.shared.open(instagramStoryURL, options: [:], completionHandler: nil)
            } else {
                makeAlert(title: "알림", message: "인스타그램이 필요합니다", okTitle: "확인")
            }
        }
    }
    
    @objc func dismissAlert() {
        dismiss(animated: false, completion: nil)
    }
    
    @objc
    private func removeTicketbook() {
        dismiss(animated: false) {
            Vibration.warning.vibrate()
            guard let row = self.deleteIndex else { return }
            self.deleteTicketBook(exhibitionID: self.ticketData[row].exhibitionID)
        }
    }
    
    /// ARtique 둘러보기 버튼 클릭시 실행되는 메서드
    private func lookAroundBtnDidTap(naviType: NaviType) {
        lookAroundBtn.press { [weak self] in
            switch naviType {
            case .push:
                self?.popVC()
            case .present:
                self?.dismissVC()
            case .dismissToRoot:
                self?.homeToRoot()
            }
        }
    }
    
    /// TicketBookDimmedVC present 화면전환 메서드
    private func presentDimmedVC(indexPath: IndexPath) {
        let dimmedVC = TicketBookDimmedVC()
        dimmedVC.selectedIndex = indexPath.row
        dimmedVC.ticketFrame = self.ticketCV.convert(ticketCV.cellForItem(at: indexPath)?.frame ?? CGRect.zero, to: self.view.superview)
        dimmedVC.ticketImageString = ticketData[indexPath.row].posterImage
        dimmedVC.exhibitionID = ticketData[indexPath.row].exhibitionID
        
        /// 티켓 수가 6 이상일 때 최하단에 있는 티켓들은 레이아웃을 다르게 present하기 위해 분기처리
        if ticketData.count > 6 {
            var divideNumber: Int?
        
            if ticketData.count % 3 == 0 {
                divideNumber = ticketData.count / 3 - 1
            } else {
                divideNumber = ticketData.count / 3
            }
            
            if indexPath.row / 3 == divideNumber {
                dimmedVC.isLocatedInBottom = true
            }
        }
        
        dimmedVC.modalTransitionStyle = .crossDissolve
        dimmedVC.modalPresentationStyle = .overFullScreen
        self.present(dimmedVC, animated: false, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource
extension TicketBookVC: UICollectionViewDataSource {

    /// numberOfSections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    /// numberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return ticketData.isEmpty ? 1 : ticketData.count
        default:
            return 0
        }
    }
    
    /// cellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let headerCell = collectionView.dequeueReusableCell(withReuseIdentifier: TicketHeaderCVC.className, for: indexPath) as? TicketHeaderCVC,
              let ticketCell = collectionView.dequeueReusableCell(withReuseIdentifier: TicketCVC.className, for: indexPath) as? TicketCVC,
              let emptyCell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyCVC.className, for: indexPath) as? EmptyCVC else { return UICollectionViewCell() }
        
        switch indexPath.section {
        case 0:
            headerCell.setUpCellbyMode(isDeleteMode: isDeleteMode)
            headerCell.setData(model: ticketData)
            return headerCell
        case 1:
            if ticketData.isEmpty {
                lookAroundBtn.isHidden = false
                return emptyCell
            } else {
                ticketCell.setUpDeleteBtnbyMode(isDeleteMode: isDeleteMode)
                ticketCell.tapDeleteBtnAction = {
                    self.deleteIndex = indexPath.row
                    Vibration.warning.vibrate()
                    self.popupAlertWithTitle(targetView: self,
                                             alertType: .deleteTicketbook,
                                             title: "'\(self.ticketData[indexPath.row].title )'",
                                             leftBtnAction: #selector(self.removeTicketbook),
                                             rightBtnAction: #selector(self.dismissAlert))
                }
                
                ticketCell.setData(model: ticketData[indexPath.row])
                lookAroundBtn.isHidden = true
                return ticketCell
            }
        default:
            return UICollectionViewCell()
        }
    }
}

// MARK: - UICollectionViewDelegate
extension TicketBookVC: UICollectionViewDelegateFlowLayout {
    
    /// sizeForItemAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: screenWidth, height: 100)
        case 1:
            if ticketData.isEmpty {
                return CGSize(width: screenWidth, height: 512.adjustedH)
            } else {
                return CGSize(width: (screenWidth - 40) / 3.2, height: 163.0)
            }
        default:
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        28
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    /// didSelectItemAt
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //✅ Cell 클릭시 dimmedVC로 화면전환 -> 배경이 흐릿해지는 기능 구현
        //✅ Cell에서 눌린 티켓을 dimmedVC에서도 동일한 위치에 그려낼 수 있도록 Cell 클릭 시 해당하는 티켓의 frame을 넘겨줌
        if indexPath.section != 0 && !ticketData.isEmpty {
            if isDeleteMode == false {
                Vibration.medium.vibrate()
                selectedIndexPath = indexPath
                UIView.animate(withDuration: 0.2, animations: { [weak self] in
                    self?.ticketCV.scrollToItem(at: indexPath, at: [.centeredHorizontally,.centeredVertically], animated: false)
                }, completion: { [weak self] _ in
                    self?.presentDimmedVC(indexPath: self?.selectedIndexPath ?? [0,0])
                })
            }
        }
    }
}

// MARK: - Network
extension TicketBookVC {
    
    /// 서버통신을 통해 티켓북 리스트를 받아오는 메서드
    private func getTicketbookList() {
        LoadingHUD.show()
        TicketAPI.shared.requestTicketbookList(completion: { [weak self] networkResult in
            switch networkResult {
            case .success(let res):
                if let data = res as? [TicketListModel] {
                    //✅ 받아온 데이터로 티켓북 리스트 구성
                    self?.ticketData = data
                    self?.ticketCV.reloadData()
                    self?.navigationItem.rightBarButtonItem?.isEnabled = self?.ticketData.isEmpty == true ? false : true
                    LoadingHUD.hide()
                }
            case .requestErr(let res):
                if let message = res as? String {
                    print(message)
                    LoadingHUD.hide()
                    self?.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                } else if res is Bool {
                    self?.requestRenewalToken() { _ in
                        self?.getTicketbookList()
                    }
                }
            default:
                LoadingHUD.hide()
                self?.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        })
    }
    
    /// 서버통신을 통해 특정 티켓북을 삭제하는 메서드
    private func deleteTicketBook(exhibitionID: Int) {
        LoadingHUD.show()
        TicketAPI.shared.requestDeleteTicketbook(exhibitionID: exhibitionID, completion: { [weak self] networkResult in
            switch networkResult {
            case .success(_):
                //✅ 티켓 삭제 성공시
                self?.getTicketbookList()
                LoadingHUD.hide()
            case .requestErr(let res):
                if let message = res as? String {
                    print(message)
                    LoadingHUD.hide()
                    self?.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                } else if res is Bool {
                    self?.requestRenewalToken() { _ in
                        self?.deleteTicketBook(exhibitionID: exhibitionID)
                    }
                }
            default:
                LoadingHUD.hide()
                self?.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        })
    }
}
