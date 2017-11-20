//
//  AppDelegate.swift
//  WareWolf
//
//  Created by falcon@mac on H29/11/19.
//  Copyright © 平成29年 NagaoLab. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    // ゲームプレイヤーの人数
    var playerCount = 4
    // 参加者の一覧
    var playerList : [Player] = []
    var roleList : [Role] = []
    
    var wereWolfRoles : [Role] = []
    var villagerRoles : [Role] = []
    var foxRoles : [Role] = []
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // 参加者を4名追加
        let player1 = Player(name: "Player1")
        let player2 = Player(name: "Player2")
        let player3 = Player(name: "Player3")
        let player4 = Player(name: "Player4")
        self.playerList = [player1,player2,player3,player4]
        // 役割一覧
        let roles = ExFileManager.readFile(forResource: "Jin-Roh", fileExtension: "csv")
        for index in 1..<roles.count {
            let roleText = roles[index].replacingOccurrences(of: "\r", with: "").replacingOccurrences(of: "\\n", with: "\n")
            if roleText.characters.count > 0 {
                let split = roleText.components(separatedBy: ",")
                let ID = Int(split[0])!
                let name = split[1]
                let detail = split[2]
                let side = Int(split[3])!
                let uranai = Int(split[4])!
                let reibai = Int(split[5])!
                let role = Role(ID: ID, name: name, detail: detail, side: side, uranai: uranai, reibai: reibai)
                if role.side == .Villager {
                    self.villagerRoles.append(role)
                }else if role.side == .WereWolf {
                    self.wereWolfRoles.append(role)
                }else if role.side == .Fox {
                    self.foxRoles.append(role)
                }
                // self.roleList.append(role)
            }
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

