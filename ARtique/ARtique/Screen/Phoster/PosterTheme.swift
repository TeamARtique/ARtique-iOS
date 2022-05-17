//
//  PosterTheme.swift
//  ARtique
//
//  Created by 황윤경 on 2022/05/16.
//

import UIKit
import SnapKit

class PosterTheme: UIView {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var overlay: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var date: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setContentView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setContentView()
    }
}

// MARK: - Configure
extension PosterTheme {
    private func setContentView() {
        guard let view = loadXibView(with: Identifiers.posterTheme) else { return }
        view.backgroundColor = .clear
        self.addSubview(view)
        
        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configurePoster(themeId: PosterType, poster: UIImage, title: String, nickname: String, date: String) {
        posterImage.image = poster
        posterImage.contentMode = .scaleAspectFill
        overlay.image = themeId.overlay
        self.title.setLineBreakMode()
        self.title.text = title
        self.title.font = themeId.titleFont
        self.title.textColor = themeId.titleColor
        self.title.textAlignment = .center
        self.author.setLineBreakMode()
        self.author.text = nickname
        self.author.font = themeId.contentFont
        self.author.textColor = themeId.contentColor
        self.author.textAlignment = .center
        self.date.text = date
        self.date.font = themeId.contentFont
        self.date.textColor = themeId.contentColor
        self.date.textAlignment = .center
        
        switch themeId {
        case .theme0:
            self.title.removeFromSuperview()
            self.author.removeFromSuperview()
            self.date.removeFromSuperview()
            posterImage.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            
        case .theme1, .theme2:
            self.author.removeFromSuperview()
            self.date.removeFromSuperview()
            posterImage.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            self.title.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(47)
                $0.bottom.equalToSuperview().offset(-43)
                $0.height.equalTo(40)
            }
            
        case .theme3, .theme4:
            self.date.removeFromSuperview()
            posterImage.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            self.title.snp.makeConstraints {
                $0.top.equalToSuperview().offset(40)
                $0.leading.equalToSuperview().offset(35)
                $0.height.equalTo(40)
            }
            self.author.snp.makeConstraints {
                $0.top.equalToSuperview().offset(100)
                $0.leading.equalToSuperview().offset(36)
            }
            
        case .theme5, .theme6:
            self.author.rotate(degrees: -90)
            self.date.rotate(degrees: 90)
            posterImage.snp.makeConstraints {
                $0.top.equalToSuperview().offset(67)
                $0.leading.equalToSuperview().offset(69)
                $0.trailing.equalToSuperview().offset(-69)
                $0.bottom.equalToSuperview().offset(-117)
            }
            self.title.snp.makeConstraints {
                $0.bottom.equalToSuperview().offset(-42)
                $0.centerX.equalToSuperview()
                $0.height.equalTo(40)
            }
            self.author.snp.makeConstraints {
                $0.centerX.equalToSuperview().offset(-128)
                $0.centerY.equalToSuperview()
            }
            self.date.snp.makeConstraints {
                $0.centerX.equalToSuperview().offset(128)
                $0.centerY.equalToSuperview()
            }
            
        case .theme7, .theme8:
            self.author.text = "\(nickname) - \(date)"
            self.author.rotate(degrees: 90)
            self.date.removeFromSuperview()
            posterImage.snp.makeConstraints {
                $0.top.equalToSuperview().offset(60)
                $0.leading.equalToSuperview().offset(45)
                $0.trailing.equalToSuperview().offset(-45)
                $0.bottom.equalToSuperview().offset(-60)
            }
            self.title.snp.makeConstraints {
                $0.center.equalToSuperview()
                $0.height.equalTo(40)
            }
            self.author.snp.makeConstraints {
                $0.centerX.equalToSuperview().offset(138)
                $0.centerY.equalToSuperview()
            }
            
        case .theme9, .theme10:
            self.author.text = "\(nickname)\n-\n\(date)"
            self.date.removeFromSuperview()
            posterImage.snp.makeConstraints {
                $0.top.equalToSuperview().offset(42)
                $0.leading.equalToSuperview().offset(57)
                $0.trailing.equalToSuperview().offset(-57)
                $0.bottom.equalToSuperview().offset(-110)
            }
            self.title.snp.makeConstraints {
                $0.bottom.equalToSuperview().offset(-84)
                $0.centerX.equalToSuperview()
                $0.height.equalTo(40)
            }
            self.author.snp.makeConstraints {
                $0.bottom.equalToSuperview().offset(-10)
                $0.centerX.equalToSuperview()
                $0.height.equalTo(75)
            }
            
        case .theme11, .theme12:
            self.author.text = "\(nickname) • \(date)"
            self.date.removeFromSuperview()
            let posterImage2 = UIImageView(image: poster)
            posterImage2.contentMode = .scaleAspectFill
            contentView.insertSubview(posterImage2, at: 0)
            posterImage.snp.makeConstraints {
                $0.top.equalToSuperview().offset(60)
                $0.leading.equalToSuperview().offset(-70)
                $0.trailing.equalToSuperview().offset(-175)
                $0.bottom.equalToSuperview().offset(-80)
            }
            posterImage2.snp.makeConstraints {
                $0.top.equalToSuperview().offset(60)
                $0.leading.equalToSuperview().offset(175)
                $0.trailing.equalToSuperview().offset(70)
                $0.bottom.equalToSuperview().offset(-80)
            }
            self.title.snp.makeConstraints {
                $0.center.equalToSuperview()
                $0.height.equalTo(40)
            }
            self.author.snp.makeConstraints {
                $0.bottom.equalToSuperview().offset(-37)
                $0.centerX.equalToSuperview()
            }
        }
    }
}
