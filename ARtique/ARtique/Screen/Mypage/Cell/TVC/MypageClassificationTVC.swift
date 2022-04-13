//
//  MypageClassificationTVC.swift
//  ARtique
//
//  Created by 황윤경 on 2022/04/09.
//

import UIKit

class MypageClassificationTVC: UITableViewCell {
    @IBOutlet weak var exhibitionType: UILabel!
    @IBOutlet weak var exhibitionCnt: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension MypageClassificationTVC {
    func configureCell(_ title: String, _ cnt: Int) {
        exhibitionType.text = title
        exhibitionCnt.text = "\(cnt)"
    }
}
