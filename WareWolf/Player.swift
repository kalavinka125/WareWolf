//
//  Player.swift
//  WareWolf
//
//  Created by falcon@mac on H29/11/20.
//  Copyright © 平成29年 NagaoLab. All rights reserved.
//

import UIKit

class Player: NSObject {
    var name = "Player"
    // 今後の拡張で画像を格納できるように
    var imageData : Data!
    
    init(name : String) {
        self.name = name
    }
}
