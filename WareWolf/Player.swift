//
//  Player.swift
//  WareWolf
//
//  Created by falcon@mac on H29/11/20.
//  Copyright © 平成29年 NagaoLab. All rights reserved.
//

import UIKit

class Player: NSObject {
    // ユーザ名
    var name = "Player"
    // 役職
    var role : Role!
    // 生存フラグ
    // T:生存,F:死
    var isLife = true
    // 疑い度
    var doubt = 0
    
    init(name : String) {
        self.name = name
    }
}
