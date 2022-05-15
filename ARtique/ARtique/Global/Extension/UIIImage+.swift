//
//  UIIImage+.swift
//  ARtique
//
//  Created by 황윤경 on 2022/05/09.
//

import UIKit

extension UIImage {
    func resized(to size: CGSize) -> UIImage? {
        let image = UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
            
        return image.withRenderingMode(renderingMode)
    }
}
