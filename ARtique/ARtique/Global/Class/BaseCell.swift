//
//  BaseCell.swift
//  ARtique
//
//  Created by 황지은 on 2021/11/29.
//

import UIKit

class BaseCell: UICollectionViewCell {
    
    //MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setupViews() {
        
    }
}

// MARK: - CVRegisterable
extension BaseCell: CVRegisterable {
    static var isFromNib: Bool {
        get {
            return true
        }
    }
}
