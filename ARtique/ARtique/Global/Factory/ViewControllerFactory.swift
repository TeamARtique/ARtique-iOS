//
//  ViewControllerFactory.swift
//  ARtique
//
//  Created by 황지은 on 2021/11/29.
//

import Foundation
import UIKit
class ViewControllerFactory: NSObject {
    static func viewController(for typeOfVC: TypeOfViewController) -> UIViewController {
        let metaData = typeOfVC.storyboardRepresentation()
        let sb = UIStoryboard(name: metaData.storyboardName, bundle: metaData.bundle)
        let vc = sb.instantiateViewController(withIdentifier: metaData.storyboardId)
        return vc
    }
}
