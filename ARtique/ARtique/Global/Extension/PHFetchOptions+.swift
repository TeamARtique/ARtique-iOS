//
//  PHFetchOptions+.swift
//  ARtique
//
//  Created by 황윤경 on 2022/03/29.
//

import UIKit
import Photos

extension PHFetchOptions {
    static var ascendingOptions: PHFetchOptions = {
        let option = PHFetchOptions()
        option.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        return option
    }()
}
