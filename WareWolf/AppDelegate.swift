//
//  AppDelegate.swift
//  WareWolf
//
//  Created by falcon@mac on H29/11/19.
//  Copyright © 平成29年 NagaoLab. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    /*
     >> 村人：0, 223, 86
     >> 人狼：223, 86, 86
     >> 狐：240, 240, 86
    */
    let villagerColor = UIColor.rgb(0, g: 223, b: 86, alpha: 1.0)
    let wereWolfColor = UIColor.rgb(223, g: 86, b: 86, alpha: 1.0)
    let foxColor = UIColor.rgb(240, g: 240, b: 86, alpha: 1.0)
    
    // 参加者の一覧
    var playerList : [Player] = []
    // 役職の一覧
    var roleList : [Role] = []
    var joinRoleList : [Role] = []
    // ヒント：役職の一覧
    var hintRoleList : [Int:Int] = [:]
    // 狼のポイントテーブル
    // ID - ポイント数
    var wolfPointList : [Int:Int] = [:]
    // 投票のポイントテーブル
    var votePointList : [Int:Int] = [:]
    // テーブル表示用の役職一覧
    var wereWolfRoles : [Role] = []
    var villagerRoles : [Role] = []
    var foxRoles : [Role] = []
    // 役職管理クラス
    let roleManager = RoleManager()
    
    // ゲーム経過ターン
    var turn = 0
    // プレイヤー番号
    var playerID = 0
    // 音楽再生クラス
    var soundPlayer : AVAudioPlayer!
    var isPause = false
    var isBattleVote = false
    // 復活した人がいる場合
    // 例：ヒロインなど
    var isReborn = false
    var rebornList : [Int] = []
    // 独裁者のID
    // 使ったら初期化すること
    var dictatorID = -1
    // 探偵のID
    var detectiveID = -1
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

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
                self.roleList.append(role)
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

    /**
     * 音楽ファイルを再生する
     * numberOfLoop : 繰り返し回数 , 0を基準(1回再生した後 , 停止)とする. -1は無限ループ
     * [重要]拡張子は必要無い
     * [重要]エラーチェック無し , ただしファイルが存在しなくても処理が継続される
     * wav ファイルのみ対応
     */
    func soundPlay(fileName : String , numberOfLoop : Int){
        let audioFilePath = Bundle.main.path(forResource: fileName, ofType: "mp3")
        if(audioFilePath != nil){
            let audioFileURL = NSURL.fileURL(withPath: audioFilePath!)
            do{
                self.soundPlayer = try AVAudioPlayer(contentsOf: audioFileURL)
                self.soundPlayer.currentTime = 0
                self.soundPlayer.numberOfLoops = numberOfLoop
                self.soundPlayer.play()
//                if(!self.soundPlayer.isPlaying){
//                    self.soundPlayer.play()
//                }
            }catch{}
        }
    }
    
    func gameRefresh() {
        let player1 = Player(name: "Player1")
        let player2 = Player(name: "Player2")
        let player3 = Player(name: "Player3")
        let player4 = Player(name: "Player4")
        self.playerList = [player1,player2,player3,player4]
        self.joinRoleList = []
        self.hintRoleList = [:]
        self.wolfPointList = [:]
        self.votePointList = [:]
        self.turn = 0
        self.playerID = 0
        self.isPause = false
        self.isBattleVote = false
        self.isReborn = false
        self.rebornList = []
        self.dictatorID = -1
        self.detectiveID = -1
    }
}

