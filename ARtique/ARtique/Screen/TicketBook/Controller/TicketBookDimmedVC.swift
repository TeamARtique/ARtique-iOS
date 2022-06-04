//
//  TicketBookDimmedVC.swift
//  ARtique
//
//  Created by hwangJi on 2022/05/20.
//

import UIKit
import SnapKit
import Then
import Kingfisher

class TicketBookDimmedVC: UIViewController {
    
    // MARK: Properties
    private let ticketView = UIImageViewWithMask().then {
        $0.maskImage = UIImage(named: "ticketFrame")
        $0.contentMode = .scaleAspectFill
    }
    private let dimmedView = UIView().then {
        $0.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    }
    
    private let optionStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.spacing = 6
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.distribution = .fill
    }
    
    private let showBtn = UIButton().then {
        $0.setImage(UIImage(named: "btn_alert_keep"), for: .normal)
    }
    
    private let shareBtn = UIButton().then {
        $0.setImage(UIImage(named: "btn_alert_share"), for: .normal)
    }
    
    private let bottomView = UIView()
    
    // MARK: Variables
    var ticketFrame: CGRect?
    var selectedIndex: Int?
    var ticketImageString: String?
    var exhibitionID: Int?
    var isLocatedInBottom: Bool?
    
    // MARK: Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setTicketValues()
        configureUI()
        btnActionMapping()
    }
}

// MARK: - UI
extension TicketBookDimmedVC {
    
    /// component들의 전체적인 UI 틀을 구성하는 메서드
    private func configureUI() {
        view.addSubviews([dimmedView, ticketView, optionStackView])
        optionStackView.addArrangedSubview(showBtn)
        optionStackView.addArrangedSubview(shareBtn)
        optionStackView.addArrangedSubview(bottomView)
        
        dimmedView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        ticketView.snp.makeConstraints {
            $0.top.equalTo(Int(ticketFrame?.minY ?? 0) + 5)
            $0.leading.equalTo(Int(ticketFrame?.minX ?? 0))
            $0.width.equalTo(Int(ticketFrame?.width ?? 0) - 4)
            $0.height.equalTo(Int(ticketFrame?.height ?? 0) - 5)
        }
        
        bottomView.snp.makeConstraints {
            $0.height.equalTo(10)
        }
        
        if isLocatedInBottom == true {
            optionStackView.snp.makeConstraints {
                $0.bottom.equalTo(ticketView.snp.top)
                $0.centerX.equalTo(ticketView)
            }
        } else {
            optionStackView.snp.makeConstraints {
                $0.top.equalTo(ticketView.snp.bottom).offset(10)
                $0.centerX.equalTo(ticketView)
            }
        }
        
        self.view.backgroundColor = .clear
    }
}

// MARK: - Custom Methods
extension TicketBookDimmedVC {
    
    /// 이전 VC로부터 ticket관련 데이터들을 받아 옵셔널이었던 값을 채워주는 메서드
    private func setTicketValues() {
        if let frame = ticketFrame {
            ticketFrame = frame
        }
        
        if let index = selectedIndex {
            selectedIndex = index
        }
        
        if let image = ticketImageString {
            ticketImageString = image
            downloadImage(with: ticketImageString ?? "")
        }
        
        if let id = exhibitionID {
            exhibitionID = id
        }
    }
    
    /// url을 image로 다운받아 imageView에 다운받은 이미지를 구성하는 메서드
    private func downloadImage(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let resource = ImageResource(downloadURL: url)
        
        DispatchQueue.global().async {
            KingfisherManager.shared.retrieveImage(with: resource,
                                                   options: nil,
                                                   progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    DispatchQueue.main.async {
                        // ticketView의 image를 다운받은 image로 구성
                        self.ticketView.image = value.image
                    }
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
    }
    
    /// touch 이벤트가 발생되면 실행되는 메서드
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: false)
    }
    
    /// 전시보기 버튼을 클릭했을 때 실행되는 메서드
    private func showBtnDidTap() {
        guard let detailVC = UIStoryboard(name: Identifiers.detailSB, bundle: nil).instantiateViewController(withIdentifier: Identifiers.detailVC) as? DetailVC else { return }
        detailVC.exhibitionID = exhibitionID
        detailVC.naviType = .present
        
        let navi = UINavigationController(rootViewController: detailVC)
        navi.modalPresentationStyle = .fullScreen
        
        guard let pvc = self.presentingViewController else { return }
        
        self.dismiss(animated: false) {
            pvc.present(navi, animated: true, completion: nil)
        }
    }
    
    /// 공유하기 버튼을 클릭했을 때 실행되는 메서드
    private func shareBtnDidTap() {
        let index: IndexPath = [1, selectedIndex ?? 0]
        NotificationCenter.default.post(name: .whenTicketShareBtnDidTap, object: nil, userInfo: ["indexPath": index])
        self.dismiss(animated: false)
    }
    
    /// 버튼을 클릭했을 때 실행되는 액션들을 맵핑하는 메서드
    private func btnActionMapping() {
        showBtn.press {
            self.showBtnDidTap()
        }
        
        shareBtn.press {
            self.shareBtnDidTap()
        }
    }
}
