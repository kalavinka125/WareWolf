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
    

    /// 人狼の殺害ターゲットを表現する!!!テキストの生成
    ///
    /// - Parameter wereWolf: 人狼からの票の集まり具合
    /// - Returns: 「！！！」で表現されたテキスト
    func generateWereWolfFlagTxt(wereWolf : Int) -> String{
        var txt = ""
        if wereWolf == 0 {
            txt = "？？？"
        }else{
            for _ in 0..<wereWolf {
                txt += "！"
            }
        }
        return txt
    }
    
    /// 最も疑われている人を調べる
    /// 同表の場合、-1を返す。
    ///
    /// - Parameter players: プレイヤー一覧
    /// - Returns: 最も疑われている人のインデックス
    func getDoubtTopPlayer(players : [Player]) -> Int {
        // 最大を求める
        var max = 0
        var maxIndex = 0
        for index in 0..<players.count {
            let player = players[index]
            if player.doubt >= max {
                max = player.doubt
                maxIndex = index
            }
        }
        // 最小を求める
        var min = 100
        for index in 0..<players.count {
            let player = players[index]
            if player.doubt <= min {
                min = player.doubt
            }
        }
        // 最大と最小の比較
        if max == min {
            // 同表
            return -1
        }else{
            // 疑われている人あり
            return maxIndex
        }
    }
    
    /// 本日の犠牲者を一覧で取得する
    ///
    /// - Parameters:
    ///   - players: 参加プレイヤー
    ///   - wereWolfPointTable: 人狼のターゲットテーブル
    /// - Returns: 犠牲者リスト
    func getVictimList(players : [Player] , wereWolfPointTable : [Int:Int],turn : Int) -> [Int]{
        var list : [Int] = []
        var maxValue = 0
        var maxKey = 0
        // すべてゼロなら
        var isAllZero = false
        for (key, value) in wereWolfPointTable {
            if value == 0 || wereWolfPointTable[key] == nil {
                isAllZero = true
            }else{
                isAllZero = false
                break
            }
        }
        if wereWolfPointTable.count == 0 || isAllZero {
            // 呪殺やサイコキラーで死んだ役職の対応
            for index in 0..<players.count {
                if players[index].role.deadEndFlag {
                    players[index].isLife = false
                    list.append(index)
                }
            }
            return list
        }
        for (key , value) in wereWolfPointTable {
            if value > maxValue {
                // 最大値を覚える
                maxValue = value
                maxKey = key

            }
        }
        
        for index in 0..<players.count {
            let player = players[index]
            // 生存している人を対象に
            if player.isLife {
                // 人狼の殺害ターゲット
                if index == maxKey {
                    // 妖狐とサイコキラー以外なら
                    if (player.role.ID != 18) || (player.role.ID != 6) {
                        if !player.role.guardFlag {
                            // 騎士やコスプレイヤーに守られていないタフガイ
                            if player.role.ID == 12 {
                                // 死ぬターンが設定されていない場合
                                if player.endTurn == -1 {
                                    player.endTurn = turn + 1
                                }else if player.endTurn == turn{
                                    // 死亡するターンなら
                                    list.append(index)
                                }
                            }else{
                                // タフガイ以外なら、即死
                                list.append(index)
                            }
                        }
                    }
                }
                // 死亡フラグが立っている場合
                if player.role.deadEndFlag {
                    list.append(index)
                }
                // タフガイの判定
                else if player.role.ID == 12 && player.endTurn == turn {
                    list.append(index)
                }
            }
        }
        return list
    }
    
    /// ゲームの勝敗を調べる
    ///
    /// - Parameter players: 全プレイヤー
    /// - Returns: 勝ったサイド、Noneならまだ決着付いていない
    func isGameOver(players : [Player]) -> Side {
        var villager = 0
        var wolf = 0
        var fox = 0
        let lifeList = self.getList(target: true, players: players)
        for life in lifeList {
            let player = players[life]
            if player.isLife {
                // 人狼
                // 狐
                // 市民
                if player.role.side == .Villager {
                    villager += 1
                }else if player.role.side == .WereWolf {
                    if player.role.ID == 1 {
                        wolf += 1
                    }else{
                        villager += 1
                    }
                }else if player.role.side == .Fox {
                    if player.role.ID == 18 || player.role.ID == 19 {
                        fox += 1
                    }else{
                        villager += 1
                    }
                }
            }
        }
        if wolf == 0 && villager == 0 {
            if fox > 0 {
                return .Fox
            }
            return .Villager
        }
        if wolf >= villager {
            if fox > 0 {
                return .Fox
            }
            return .WereWolf
        }else if wolf == 0{
            if fox > 0 {
                return .Fox
            }
            return .Villager
        }
        return .None
    }
    
    func nekomata(players : [Player], nekomataID : Int) {
        for player in players {
            // 発動した猫又以外の
            if player.isLife && player.role.ID != nekomataID {
                
            }
        }
    }
}
