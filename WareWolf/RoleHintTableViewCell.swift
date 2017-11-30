//
//  RoleHintTableViewCell.swift
//  WareWolf
//
//  Created by falcon@mac on H29/12/01.
//  Copyright © 平成29年 NagaoLab. All rights reserved.
//

import UIKit

class RoleHintTableViewCell: UITableViewCell {

    @IBOutlet weak var roleImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sideLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
