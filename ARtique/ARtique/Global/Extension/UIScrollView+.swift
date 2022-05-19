//
//  UIScrollView+.swift
//  ARtique
//
//  Created by 황윤경 on 2022/03/23.
//

import UIKit

extension UIScrollView {
    var bottomOffset: Double {
        contentSize.height - bounds.size.height + contentInset.bottom
    }
    
    func scrollToTop() {
        let topOffset = CGPoint(x: 0, y: 0)
        self.setContentOffset(topOffset, animated: true)
    }
    
    func scrollToBottom(animated: Bool) {
      if self.contentSize.height < self.bounds.size.height { return }
        let bottomOffset = CGPoint(x: 0, y: bottomOffset)
        self.setContentOffset(bottomOffset, animated: animated)
    }
}
