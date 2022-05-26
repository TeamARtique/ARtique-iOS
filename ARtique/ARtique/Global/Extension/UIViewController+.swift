//
//  UIViewController+.swift
//  ARtique
//
//  Created by 황윤경 on 2022/03/15.
//

import UIKit
import SnapKit

extension UIViewController {
    
    /// className을 String으로 반환하는 프로퍼티
    static var className: String {
        NSStringFromClass(self.classForCoder()).components(separatedBy: ".").last!
    }
    
    var className: String {
        NSStringFromClass(self.classForCoder).components(separatedBy: ".").last!
    }
    
    /// 화면 터치 시 키보드 내리는 함수
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    /// 화면 터치 시 키보드 내리는 함수
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    /**
     - Description:
     VC나 View 내에서 해당 함수를 호출하면, 햅틱이 발생하는 메서드입니다.
     버튼을 누르거나 유저에게 특정 행동이 발생했다는 것을 알려주기 위해 다음과 같은 햅틱을 활용합니다.
     
     - parameters:
     - degree: 터치의 세기 정도를 정의. 보통은 medium,light를 제일 많이 활용합니다.
     */
    func makeVibrate(degree : UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let generator = UIImpactFeedbackGenerator(style: degree)
        generator.impactOccurred()
    }
    
    /// 기기 스크린 hight에 맞춰 비율을 계산해 height를 리턴하는 함수
    func calculateHeightbyScreenHeight(originalHeight: CGFloat) -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        return originalHeight * (screenHeight / 812)
    }
    
    /// 확인 버튼 Alert 메서드
    func makeAlert(title : String, message : String? = nil,
                   okTitle: String = "확인", okAction : ((UIAlertAction) -> Void)? = nil,
                   completion : (() -> Void)? = nil) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        let alertViewController = UIAlertController(title: title, message: message,
                                                    preferredStyle: .alert)
        let okAction = UIAlertAction(title: okTitle, style: .default, handler: okAction)
        alertViewController.addAction(okAction)
        self.present(alertViewController, animated: true, completion: completion)
    }
    
    /// ARtique 커스텀 Alert 메서드
    func popupAlert(targetView: UIViewController, alertType: AlertType, image: UIImage?,  leftBtnAction: Selector?, rightBtnAction: Selector) {
        guard let alert = UIStoryboard(name: Identifiers.alertSB, bundle: nil).instantiateViewController(withIdentifier: Identifiers.alertVC) as? AlertVC else { return }
        alert.configureAlert(targetView: targetView,
                             alertType: alertType,
                             image: image,
                             leftBtnAction: leftBtnAction,
                             rightBtnAction: rightBtnAction)
        alert.modalPresentationStyle = .overFullScreen
        present(alert, animated: false, completion: nil)
    }
    
    /// 전시 타이틀 추가 가능한 전시, 전시 티켓 삭제 확인용 Alert
    func popupAlertWithTitle(targetView: UIViewController, alertType: AlertType, title: String, leftBtnAction: Selector?, rightBtnAction: Selector) {
        guard let alert = UIStoryboard(name: Identifiers.alertSB, bundle: nil).instantiateViewController(withIdentifier: Identifiers.alertVC) as? AlertVC else { return }
        alert.configureAlertWithTitle(targetView: targetView,
                                      alertType: alertType,
                                      title: title,
                                      leftBtnAction: leftBtnAction,
                                      rightBtnAction: rightBtnAction)
        alert.modalPresentationStyle = .overFullScreen
        present(alert, animated: false, completion: nil)
    }
    
    func popupToast(toastType: ToastType) {
        let toastView = ToastView()
        toastView.message.text = toastType.message
        view.addSubview(toastView)
        
        if toastType.position == "top" {
            toastView.snp.makeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
                $0.leading.equalToSuperview().offset(20)
                $0.trailing.equalToSuperview().offset(-20)
                $0.height.equalTo(46)
            }
        } else {
            toastView.snp.makeConstraints {
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
                $0.leading.equalToSuperview().offset(20)
                $0.trailing.equalToSuperview().offset(-20)
                $0.height.equalTo(46)
            }
        }
        
        UIView.animate(withDuration: 1.0, delay: 0.5, options: .curveEaseOut, animations: {
            toastView.alpha = 0.0
        }, completion: {(isCompleted) in
            toastView.removeFromSuperview()
        })
    }
}
