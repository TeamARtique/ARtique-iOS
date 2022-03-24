//
//  OrderView.swift
//  ARtique
//
//  Created by 황윤경 on 2022/03/22.
//

import UIKit

class OrderView: UIView {
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var artworkListView: ArtworkListView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setContentView()
        configureMessage()
        bindViewGesture()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setContentView()
        configureMessage()
        bindViewGesture()
    }
    
    private func setContentView() {
        guard let view = loadXibView(with: Identifiers.orderView) else { return }
        view.backgroundColor = .clear
        self.addSubview(view)
        
        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configureMessage() {
        message.textColor = .lightGray
        message.font = .AppleSDGothicR(size: 12)
    }
    
    private func bindViewGesture() {
        artworkListView.bindCVReorderGesture()
    }
}
