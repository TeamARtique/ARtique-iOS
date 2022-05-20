//
//  ToastView.swift
//  ARtique
//
//  Created by 황윤경 on 2022/05/19.
//

import UIKit

class ToastView: UIView {
    @IBOutlet weak var message: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setContentView()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setContentView()
        configureView()
    }
}

// MARK: - Configure
extension ToastView {
    private func setContentView() {
        guard let view = loadXibView(with: Identifiers.toastView) else { return }
        view.backgroundColor = .clear
        self.addSubview(view)
        
        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configureView() {
        backgroundColor = .black
        layer.opacity = 0.76
        layer.cornerRadius = 5
        
        message.font = .AppleSDGothicSB(size: 13)
        message.textColor = .white
    }
    
    func setMessage(message: String) {
        self.message.text = message
    }
}
