//
//  RollTableViewCell.swift
//  WareWolf
//
//  Created by falcon@mac on H29/11/20.
//  Copyright © 平成29年 NagaoLab. All rights reserved.
//

import UIKit

protocol RollTableViewCellDelegate {
    func tappedPlusButton(indexPath : IndexPath)
    func tappedMinusButton(indexPath : IndexPath)
}
class RollTableViewCell: UITableViewCell {
    var delegate : RollTableViewCellDelegate!
    var indexPath : IndexPath!
    
    @IBOutlet weak var rollImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberOfRollLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func tappedMinusButton(_ sender: Any) {
        if self.delegate != nil {
            self.delegate.tappedMinusButton(indexPath: self.indexPath)
        }
    }
    
    @IBAction func tappedPlusButton(_ sender: Any) {
        if self.delegate != nil {
            self.delegate.tappedPlusButton(indexPath: self.indexPath)
        }
    }
}
