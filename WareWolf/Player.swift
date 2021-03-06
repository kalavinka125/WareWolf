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
    var prevRole : Role!
    var role : Role!
    var newRole : Role!
    // 生存フラグ
    // T:生存,F:死
    var isLife = true
    // 疑い度
    var doubt = 0
    // 能力のターゲット
    var target = -1
    // 投票のターゲット
    var voteTarget = -1
    // 決選投票の対象か
    var isBattleVote = false
    // マジシャンの交換対象になってないか
    var isChange = false
    // 死ぬターンを決める
    // 基本タフガイ用
    var endTurn = -1
    
    init(name : String) {
        self.name = name
    }
}
