//
//  TypeOfViewController.swift
//  ARtique
//
//  Created by 황지은 on 2021/11/29.
//

import Foundation
enum TypeOfViewController {
    case tabBar
    case home
    case add
    case mypage
    case arGallery
    case category
}

extension TypeOfViewController {
    func storyboardRepresentation() -> StoryboardRepresentation {
        switch self {
        case .tabBar:
            return StoryboardRepresentation(bundle: nil, storyboardName: Identifiers.tabBarSB, storyboardId: Identifiers.artiqueTBC)
        case .home:
            return StoryboardRepresentation(bundle: nil, storyboardName: Identifiers.homeSB, storyboardId: Identifiers.homeNC)
        case .add:
            return StoryboardRepresentation(bundle: nil, storyboardName: Identifiers.addSB, storyboardId: Identifiers.addExhibitionNC)
        case .mypage:
            return StoryboardRepresentation(bundle: nil, storyboardName: Identifiers.mypageSB, storyboardId: Identifiers.mypageNC)
        case .arGallery:
            return StoryboardRepresentation(bundle: nil, storyboardName: Identifiers.arGallerySB, storyboardId: Identifiers.planeRecognitionVC)
        case .category:
            return StoryboardRepresentation(bundle: nil, storyboardName: Identifiers.homeListSB, storyboardId: Identifiers.homeListVC)
        }
    }
}
