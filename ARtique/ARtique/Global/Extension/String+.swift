//
//  String+.swift
//  ARtique
//
//  Created by hwangJi on 2022/04/28.
//

import UIKit

extension String {
    public func getViewController() -> UIViewController? {
        if let appName = Bundle.main.infoDictionary?["CFBundleName"] as? String {
            if let viewControllerType = Bundle.main.classNamed("\(appName).\(self)") as? UIViewController.Type {
                return viewControllerType.init()
            }
        }
        return nil
    }
}
