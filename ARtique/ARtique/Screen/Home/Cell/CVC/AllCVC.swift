//
//  AllCVC.swift
//  ARtique
//
//  Created by 황윤경 on 2021/12/05.
//

import UIKit

class AllCVC: UICollectionViewCell {
    @IBOutlet weak var phoster: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        phoster.contentMode = .scaleAspectFill
    }
}
