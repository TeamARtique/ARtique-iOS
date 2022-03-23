//
//  UIScrollView+.swift
//  ARtique
//
//  Created by 황윤경 on 2022/03/23.
//

import UIKit

extension UIScrollView {
    func scrollToBottom() {
      if self.contentSize.height < self.bounds.size.height { return }
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        self.setContentOffset(bottomOffset, animated: true)
    }
}