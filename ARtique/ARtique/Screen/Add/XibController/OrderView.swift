//
//  OrderView.swift
//  ARtique
//
//  Created by 황윤경 on 2022/03/22.
//

import UIKit
import SnapKit

class OrderView: UIView {
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var artworkListView: ArtworkListView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setContentView()
        configureMessage()
        configureArtworkView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setContentView()
        configureMessage()
        configureArtworkView()
    }
}

// MARK: - Configure
extension OrderView {
    private func setContentView() {
        guard let view = loadXibView(with: Identifiers.orderView) else { return }
        view.backgroundColor = .clear
        self.addSubview(view)
        
        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configureMessage() {
        message.textColor = .gray3
        message.font = .AppleSDGothicR(size: 12)
    }
    
    private func configureArtworkView() {
        artworkListView.isOrderView = true
        artworkListView.bindCVReorderGesture()
        artworkListView.artworkCV.allowsSelection = false
    }
}
