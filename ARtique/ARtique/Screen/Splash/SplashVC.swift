//
//  SplashVC.swift
//  ARtique
//
//  Created by 황윤경 on 2022/05/24.
//

import UIKit
import Lottie
import Then
import SnapKit

class SplashVC: UIViewController {
    let splash = AnimationView(name: "splash")
        .then {
            $0.contentMode = .scaleAspectFill
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureContentView()
        setRootViewWhenAnimationComplited()
    }
}

// MARK: - Configure
extension SplashVC {
    private func configureContentView() {
        view.addSubview(splash)
        splash.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(80)
            $0.trailing.equalToSuperview().offset(-80)
            $0.height.equalTo(splash.snp.width).multipliedBy(31.0/27.0)
            $0.centerY.equalToSuperview()
        }
    }
    
    private func setRootViewWhenAnimationComplited() {
        splash.play { finish in
            let window = UIWindow(frame: UIScreen.main.bounds)
            
            if UserDefaults.standard.string(forKey: UserDefaults.Keys.refreshToken) != nil {
                window.rootViewController = ARtiqueTBC()
            } else {
                window.rootViewController = LoginVC()
            }
            
            let ad = UIApplication.shared.delegate as! AppDelegate
            ad.window = window
            window.makeKeyAndVisible()
            
            if UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) == nil {
                guard let onboarding = UIStoryboard(name: Identifiers.onboardingSB, bundle: nil).instantiateViewController(withIdentifier: Identifiers.onboardingVC) as? OnboardingVC else { return }
                onboarding.modalPresentationStyle = .fullScreen
                window.rootViewController?.present(onboarding, animated: true, completion: nil)
            }
        }
    }
}
