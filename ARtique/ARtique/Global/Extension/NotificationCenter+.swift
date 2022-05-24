import Foundation
import RxSwift

/// Keyboard Event Info
typealias KeyboardAnimationInfo = (height: CGFloat, duration: Double, curve: UInt)

extension NotificationCenter {
  private func keyboardAnimationUserInfo(by notification: Notification) -> KeyboardAnimationInfo {
    let height = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?
      .cgRectValue.height ?? 0

    let duration: Double = (notification
      .userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double) ?? .zero

    let curve: UInt = (notification
      .userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt) ?? .zero

    return (height, duration, curve)
  }

  /// 키보드가 사라질 때 키보드 높이를 함께 반환하는 Observable
  func keyboardWillHideObservable() -> Observable<KeyboardAnimationInfo> {
    NotificationCenter.default.rx
      .notification(UIResponder.keyboardWillHideNotification)
      .compactMap { [weak self] notification -> KeyboardAnimationInfo? in
        self?.keyboardAnimationUserInfo(by: notification)
      }
  }

  /// 키보드가 나타날 때 키보드 높이를 함께 반환하는 Observable
  func keyboardWillShowObservable() -> Observable<KeyboardAnimationInfo> {
    NotificationCenter.default.rx
      .notification(UIResponder.keyboardWillShowNotification)
      .compactMap { [weak self] notification -> KeyboardAnimationInfo? in
        self?.keyboardAnimationUserInfo(by: notification)
      }
  }

  /// 키보드 나타난 후 높이 반환
  func keyboardDidShowObservable() -> Observable<KeyboardAnimationInfo> {
    NotificationCenter.default.rx
      .notification(UIResponder.keyboardDidShowNotification)
      .compactMap { [weak self] notification -> KeyboardAnimationInfo? in
        self?.keyboardAnimationUserInfo(by: notification)
      }
  }

  /// 키보드 변경 시 높이 반환 Observable
  func keyboardWillChangeFrame() -> Observable<KeyboardAnimationInfo> {
    NotificationCenter.default.rx
      .notification(UIResponder.keyboardWillChangeFrameNotification)
      .compactMap { [weak self] notification -> KeyboardAnimationInfo? in
        self?.keyboardAnimationUserInfo(by: notification)
      }
  }

  /// 키보드 변경 후 높이 반환 Observable
  func keyboardDidChangeFrameNotification() -> Observable<KeyboardAnimationInfo> {
    NotificationCenter.default.rx
      .notification(UIResponder.keyboardDidChangeFrameNotification)
      .compactMap { [weak self] notification -> KeyboardAnimationInfo? in
        self?.keyboardAnimationUserInfo(by: notification)
      }
  }

  /// 앱 비활성화
  func applicationWillResignActive() -> Observable<Notification> {
    NotificationCenter.default.rx
      .notification(UIApplication.willResignActiveNotification)
  }

  /// 앱 활성화
  func applicationDidBecomeActive() -> Observable<Notification> {
    NotificationCenter.default.rx
      .notification(UIApplication.didBecomeActiveNotification)
  }

  /// 투명도 감소 변경
  func reduceTransparencyStatusDidChange() -> Observable<Bool> {
    NotificationCenter.default.rx
      .notification(UIAccessibility.reduceTransparencyStatusDidChangeNotification)
      .map { _ in UIAccessibility.isReduceTransparencyEnabled }
  }

  /// UIMenuController 닫힘
  func uiMenuControllerWillHideMenuNotification() -> Observable<Notification> {
    NotificationCenter.default.rx
      .notification(UIMenuController.willHideMenuNotification)
  }

  /// UIMenuController 열림
  func uiMenuControllerWillShowMenuNotification() -> Observable<Notification> {
    NotificationCenter.default.rx
      .notification(UIMenuController.willShowMenuNotification)
  }
}
