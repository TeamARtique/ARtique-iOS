//
//  Notification+Name.swift
//  ARtique
//
//  Created by 황지은 on 2021/11/29.
//

import UIKit

extension Notification.Name {
    //Notification을 사용할 때 Name을 Extension으로 입력해주세요.
    static let whenExhibitionListTVScrolledUp = Notification.Name("whenExhibitionListTVScrolledUp")
    static let whenExhibitionListTVScrolledDown = Notification.Name("whenExhibitionListTVScrolledDown")
    static let whenAllExhibitionBtnSelected = Notification.Name("whenAllExhibitionBtnSelected")
    static let changeFirstResponder = Notification.Name("changeFirstResponder")
    static let whenTicketShareBtnDidTap = Notification.Name("whenTicketShareBtnDidTap")
}
