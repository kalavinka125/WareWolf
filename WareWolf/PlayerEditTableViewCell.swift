//
//  PlayerEditTableViewCell.swift
//  WareWolf
//
//  Created by falcon@mac on H29/11/20.
//  Copyright © 平成29年 NagaoLab. All rights reserved.
//

import UIKit

protocol PlayerEditTableViewCellDelegate {
    func tappedChangeButton(row : Int)
}

class PlayerEditTableViewCell: UITableViewCell {
    // デリゲート
    var delegate : PlayerEditTableViewCellDelegate!
    // 行番号
    var row = 0
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func tappedChangedButton(_ sender: Any) {
        if self.delegate != nil {
            self.delegate.tappedChangeButton(row: self.row)
        }
    }
}
