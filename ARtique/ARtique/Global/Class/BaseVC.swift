//
//  BaseVC.swift
//  ARtique
//
//  Created by hwangJi on 2022/04/27.
//

import UIKit
import FirebaseStorage

class BaseVC: UIViewController {
    
    // MARK: Properties
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    let storage = Storage.storage()
    var navigator: Navigator?
    
    // MARK: Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setNaviBar()
    }
}

// MARK: - Custom Methods
extension BaseVC {
    func setNaviBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func hideTabbar() {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func showTabbar() {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    /// 로그인 시 유저의 정보를 저장하는 메서드
    func setUserInfo(userID: Int, userEmail: String, nickname: String, accessToken: String, refreshToken: String) {
        TokenInfo.shared.accessToken = accessToken
        UserDefaults.standard.set(userID, forKey: UserDefaults.Keys.userID)
        UserDefaults.standard.set(userEmail, forKey: UserDefaults.Keys.userEmail)
        UserDefaults.standard.set(nickname, forKey: UserDefaults.Keys.nickname)
        UserDefaults.standard.set(refreshToken, forKey: UserDefaults.Keys.refreshToken)
        UserDefaults.standard.set(false, forKey: UserDefaults.Keys.reconnect)
    }
    
    /// 로그아웃 시 유저의 정보를 삭제하는 메서드
    func deleteUserInfo() {
        UserDefaults.standard.set(nil, forKey: UserDefaults.Keys.userID)
        UserDefaults.standard.set(nil, forKey: UserDefaults.Keys.userEmail)
        UserDefaults.standard.set(nil, forKey: UserDefaults.Keys.nickname)
        UserDefaults.standard.set(nil, forKey: UserDefaults.Keys.refreshToken)
        UserDefaults.standard.set(nil, forKey: UserDefaults.Keys.completeSignup)
        UserDefaults.standard.set(true, forKey: UserDefaults.Keys.reconnect)
    }
    
    @objc func popVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func dismissVC() {
        self.dismiss(animated: true)
    }
    
    /// 홈을 rootViewController로 만들어주는 함수
    @objc func homeToRoot() {
        self.dismiss(animated: false) {
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            let window = windowScene?.windows.first(where: { $0.isKeyWindow })
            
            window?.rootViewController?.dismiss(animated: true)
        }
    }
    
    /// 데이터만 reload 되고 tableView가 위로 스크롤 되지 않게 하는 함수
    func reloadWithoutScroll(tableView: UITableView) {
        let contentOffset = tableView.contentOffset
        tableView.reloadData()
        tableView.layoutIfNeeded()
        tableView.setContentOffset(contentOffset, animated: false)
    }
    
    /// 프로필 사진 상세보기 뷰를 띄워주는 함수
    func showProfileImage(with image: UIImage) {
        let profileImageVC = ProfileImageVC()
        profileImageVC.profileImage.image = image
        profileImageVC.modalPresentationStyle = .overFullScreen
        present(profileImageVC, animated: true, completion: nil)
    }
    
    /// safeArea top영역 높이를 반환하는 함수
    func safeAreaTopInset() -> CGFloat {
        let height = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        if #available(iOS 13.0, *) {
            let scenes = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let topPadding = scenes?.windows.first?.safeAreaInsets.top
            return topPadding ?? height
        } else {
            return height
        }
    }
    
    /// firebaseStorage에 이미지를 업로드하고, 업로드된 URL String을 escaping closure로 반환하는 메서드
    func uploadImageToFirebaseStorage(image: UIImage, completion: @escaping (String) -> ()) {
        var data = Data()
        data = image.jpegData(compressionQuality: 1.0) ?? Data()
        
        let filePath = "/\(Int.random(in: 1..<1000000000000))"
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        
        DispatchQueue.global().async {
            self.storage.reference().child(filePath).putData(data, metadata: metaData) { (metaData, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                } else {
                    self.storage.reference().child(filePath).downloadURL { (url, error) in
                        if let url = url {
                            completion(String(describing: url))
                        }
                    }
                }
            }
        }
    }
    
    /// 포스터 이미지를 생성하는 메서드
    func makePoster(posterBase: UIImage, posterTheme: Int, title: String) -> UIImage {
        let posterView = UIView()
        view.insertSubview(posterView, at: 0)
        
        let posterImage = PosterTheme()
        posterImage.translatesAutoresizingMaskIntoConstraints = false
        posterImage.configurePoster(themeId: PosterType.allCases[posterTheme],
                                    poster: posterBase,
                                    title: title,
                                    nickname: UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) ?? "ARTI",
                                    date: Date().toString())
        posterView.insertSubview(posterImage.contentView, at: 0)
        
        let poster = posterImage.contentView.transfromToImage() ?? UIImage(named: "DefaultPoster")!
        posterView.removeFromSuperview()
        
        return poster
    }
}

// MARK: - Network
extension BaseVC {
    // TODO: 액세스 토큰 갱신 API 등 다른 VC에서도 호출되는 네트워크 코드를 여기다가 만들어줍니다.
    
    /// 엑세스 토큰 갱신, 자동로그인 요청 메서드
    func requestRenewalToken(completion: @escaping (Bool) -> (Void)) {
        AuthAPI.shared.renewalTokenAPI(refreshToken: UserDefaults.standard.string(forKey: UserDefaults.Keys.refreshToken) ?? "", completion: { networkResult in
            switch networkResult {
            case .success(let res):
                if let data = res as? Token {
                    TokenInfo.shared.accessToken = data.accessToken
                    completion(true)
                }
            case .requestErr(let res):
                if let message = res as? String {
                    print(message)
                    self.requestRenewalToken() { _ in }
                } else if res is Bool {
                    // ⚠️[유효하지 않은 토큰 정보로 인해 statusCode가 401로 반환될 때]
                    /// ➡️ 리프레시 토큰(30일)이 만료된 경우이므로 보안을 위해 강제 로그아웃 처리
                    /// ❎ 로그아웃시 저장된 Userdefaults 삭제 후 로그인 창으로 이동
                    self.logoutAndPresentToLoginVC()
                }
            default:
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        })
    }
    
    /// 로그아웃을 시키는 메서드
    func logoutAndPresentToLoginVC() {
        /// ❎ 로그아웃시 저장된 Userdefaults 삭제 후 로그인 창으로 이동
        self.deleteUserInfo()
        let loginVC = LoginVC()
        loginVC.modalPresentationStyle = .fullScreen
        self.present(loginVC, animated: true, completion: nil)
    }
}

