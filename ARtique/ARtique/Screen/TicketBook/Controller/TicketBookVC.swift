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
    
    // MARK: Variables
    private var ticketData: [TicketListModel] = []
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDelegate()
        registerCell()
        configureNaviBar()
        configureUI()
        getTicketbookList()
        navigationController?.additionalSafeAreaInsets.top = 0
        NotificationCenter.default.addObserver(self, selector: #selector(shareToInstagramStory(_:)), name: .whenTicketShareBtnDidTap, object: nil)
    }
}

// MARK: - UI
extension TicketBookVC {
    
    /// 네비게이션 바를 구성하는 메서드
    private func configureNaviBar() {
        navigationItem.title = "티켓북"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "BackBtn"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(popVC))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "btn_delete"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didTapTrashBtn))
    }
    
    /// 전체 UI를 구성하는 메서드
    private func configureUI() {
        view.addSubview(ticketCV)
        
        ticketCV.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
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
    }
    
    /// 티켓북 삭제 버튼을 클릭했을 때 실행되는 메서드
    @objc
    private func didTapTrashBtn() {
        print("삭제 버튼 클릭")
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
            return ticketData.count
        default:
            return 0
        }
    }
    
    /// cellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let headerCell = collectionView.dequeueReusableCell(withReuseIdentifier: TicketHeaderCVC.className, for: indexPath) as? TicketHeaderCVC,
              let ticketCell = collectionView.dequeueReusableCell(withReuseIdentifier: TicketCVC.className, for: indexPath) as? TicketCVC else { return UICollectionViewCell() }
        
        switch indexPath.section {
        case 0:
            headerCell.setData(model: ticketData)
            return headerCell
        case 1:
            ticketCell.setData(model: ticketData[indexPath.row])
            return ticketCell
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
            return CGSize(width: screenWidth, height: 100.0)
        case 1:
            return CGSize(width: 106.0, height: 163.0)
        default:
            return CGSize.zero
        }
    }
    
    /// didSelectItemAt
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //✅ Cell 클릭시 dimmedVC로 화면전환 -> 배경이 흐릿해지는 기능 구현
        //✅ Cell에서 눌린 티켓을 dimmedVC에서도 동일한 위치에 그려낼 수 있도록 Cell 클릭 시 해당하는 티켓의 frame을 넘겨줌
        let dimmedVC = TicketBookDimmedVC()
        dimmedVC.selectedIndex = indexPath.row
        dimmedVC.ticketFrame = collectionView.cellForItem(at: indexPath)?.frame
        dimmedVC.ticketImageString = ticketData[indexPath.row].posterImage
        dimmedVC.exhibitionID = ticketData[indexPath.row].exhibitionID
        dimmedVC.modalPresentationStyle = .overFullScreen
        self.present(dimmedVC, animated: false, completion: nil)
    }
}

// MARK: - Network
extension TicketBookVC {
    
    /// 서버통신을 통해 티켓북 리스트를 받아오는 메서드
    private func getTicketbookList() {
        TicketAPI.shared.requestTicketbookList(completion: { [weak self] networkResult in
            switch networkResult {
            case .success(let res):
                if let data = res as? [TicketListModel] {
                    //✅ 받아온 데이터로 티켓북 리스트 구성
                    self?.ticketData = data
                    self?.ticketCV.reloadData()
                }
            case .requestErr(let res):
                if let message = res as? String {
                    print(message)
                    self?.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                }
            default:
                self?.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        })
    }
}
