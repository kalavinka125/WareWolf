//
//  Role.swift
//  WareWolf
//
//  Created by falcon@mac on H29/11/20.
//  Copyright © 平成29年 NagaoLab. All rights reserved.
//

import UIKit

enum Side {
    case None
    case Villager
    case WereWolf
    case Fox
    case Etc
}

/// 人狼ゲームにおける役割
class Role: NSObject {
    // #ID,役職名,説明文,属性(0:村人 1:狼 2:狐 3:etc),占い結果,霊媒結果
    var ID = -1
    var name = ""
    var detail = ""
    var side = Side.None
    var uranai = Side.None
    var reibai = Side.None
    
    var uranaiResult : [Int : Side] = [:]
    // 死亡フラグ
    var deadEndFlag = false
    // 人狼襲撃フラグ
    var wereWolfFlag = false
    // 防御フラグ
    var guardFlag = false
    
    /// 初期化
    ///
    /// - Parameters:
    ///   - ID: 役職番号
    ///   - name: 役職名
    ///   - detail: 詳細
    ///   - side: 何陣営
    ///   - uranai: 占い結果
    ///   - reibai: 霊媒結果
    init(ID:Int,name:String,detail:String,side:Int,uranai:Int,reibai:Int){
        self.ID = ID
        self.name = name
        self.detail = detail
        self.side = Role.number2Side(number: side)
        self.uranai = Role.number2Side(number: uranai)
        self.reibai = Role.number2Side(number: reibai)
    }
    
    /// 何陣営かを判定する
    ///
    /// - Parameter number:番号
    /// - Returns:何サイドか
    class func number2Side(number : Int) -> Side{
        if number == 0 {
            return Side.Villager
        }else if number == 1 {
            return Side.WereWolf
        }else if number == 2 {
            return Side.Fox
        }else if number == 3 {
            return Side.Etc
        }
        return Side.None
    }
}
