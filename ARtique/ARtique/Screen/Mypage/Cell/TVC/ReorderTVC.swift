//
//  ReorderTVC.swift
//  ARtique
//
//  Created by 황윤경 on 2022/04/15.
//

import UIKit

class ReorderTVC: UITableViewCell {
    @IBOutlet weak var reorderTitle: UILabel!
    @IBOutlet weak var checkmark: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
