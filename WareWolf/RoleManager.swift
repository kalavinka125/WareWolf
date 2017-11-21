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
}
