//
//  RoleManager.swift
//  WareWolf
//
//  Created by falcon@mac on H29/11/21.
//  Copyright © 平成29年 NagaoLab. All rights reserved.
//

import UIKit

class RoleManager: NSObject {
    func defaultRoleList(numberOfPlayer : Int) -> [Int:Int]{
        // 4 ~ 15
        switch numberOfPlayer {
        case 4:
            return [0:2,1:1,2:1]
        case 5:
            return [0:3,1:1,2:1]
        case 6:
            return [0:2,1:2,2:1,4:1]
        case 7:
            return [0:3,1:2,2:1,4:1]
        case 8:
            return [0:3,1:2,2:1,4:1,5:1]
        case 9:
            return [0:4,1:2,2:1,4:1,5:1]
        case 10:
            return [0:4,1:2,2:1,4:1,5:1,3:1]
        case 11:
            return [0:4,1:3,2:1,4:1,5:1,3:1]
        case 12:
            return [0:5,1:3,2:1,4:1,5:1,3:1]
        case 13:
            return [0:6,1:3,2:1,4:1,5:1,3:1]
        case 14:
            return [0:6,1:3,2:1,4:1,5:1,3:1,19:1]
        case 15:
            return [0:5,1:3,2:1,4:1,5:2,3:1,19:1,10:1]
        default:
            return [:]
        }
    }
    
    /// IDから役職を求める
    ///
    /// - Parameters:
    ///   - ID: ID
    ///   - roleList: 役職一覧
    /// - Returns: IDに該当する役職
    func ID2Role(ID : Int , roleList : [Role]) -> Role? {
        for role in roleList {
            if role.ID == ID {
                return role
            }
        }
        return nil
    }
    
    /// 生存者 or 死んだプレイヤーのインデックスを返す
    ///
    /// - Parameters:
    ///   - target: true:生存,false:死亡
    ///   - players: プレイヤー一覧
    /// - Returns: 指定したステータスのプレイヤーインデックスを格納した配列
    func getList(target : Bool, players : [Player]) -> [Int] {
        var list : [Int] = []
        for index in 0..<players.count {
            if players[index].isLife == target {
                list.append(index)
            }
        }
        return list
    }
}
