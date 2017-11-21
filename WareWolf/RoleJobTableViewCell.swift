//
//  RoleJobTableViewCell.swift
//  WareWolf
//
//  Created by falcon@mac on H29/11/21.
//  Copyright © 平成29年 NagaoLab. All rights reserved.
//

import UIKit

protocol RoleJobTableViewCellDelegate {
    func tappedRoleJobButton(indexPath : IndexPath)
}

class RoleJobTableViewCell: UITableViewCell {
    var delegate : RoleJobTableViewCellDelegate!
    var indexPath : IndexPath!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var jobButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func tappedJobButton(_ sender: Any) {
        if self.delegate != nil && self.indexPath != nil {
            self.delegate.tappedRoleJobButton(indexPath: self.indexPath)
        }
    }

}
