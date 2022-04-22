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
    static let whenArtworkSelected = Notification.Name("whenArtworkSelected")
    static let whenAlbumListBtnSelected = Notification.Name("whenAlbumListBtnSelected")
    static let whenAlbumChanged = Notification.Name("whenAlbumChanged")
    static let whenAllExhibitionBtnSelected = Notification.Name("whenAllExhibitionBtnSelected")
}
