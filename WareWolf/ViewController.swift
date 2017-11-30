//
//  ViewController.swift
//  WareWolf
//
//  Created by falcon@mac on H29/11/19.
//  Copyright © 平成29年 NagaoLab. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let NEWGAME_SEGUE = "GO_TO_NEWGAME"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tappedNewGameButton(_ sender: Any) {
        /*
        let player1 = Player(name: "Player1")
        let player2 = Player(name: "Player2")
        let player3 = Player(name: "Player3")
        let player4 = Player(name: "Player4")
        self.appDelegate.playerList = [player1,player2,player3,player4]
        self.appDelegate.joinRoleList = []
        self.appDelegate.hintRoleList = [:]
        self.appDelegate.wolfPointList = [:]
        self.appDelegate.votePointList = [:]
        self.appDelegate.turn = 0
        self.appDelegate.playerID = 0
        self.appDelegate.isPause = false
        self.appDelegate.isBattleVote = false
        self.appDelegate.isReborn = false
        self.appDelegate.rebornList = []
        self.appDelegate.dictatorID = -1
        // 初期化
        for player in self.appDelegate.playerList {
            player.role = nil
        }
        */
        self.appDelegate.gameRefresh()
        self.performSegue(withIdentifier: self.NEWGAME_SEGUE, sender: self)
    }

    @IBAction func tappedContinueButton(_ sender: Any) {
        self.appDelegate.gameRefresh()
        if self.appDelegate.userDefaults.array(forKey: "names") != nil && self.appDelegate.userDefaults.array(forKey: "roleKeys") != nil && self.appDelegate.userDefaults.array(forKey: "roleValues") != nil {
            // プレイヤー一覧は初期化
            self.appDelegate.playerList = []
            let names = self.appDelegate.userDefaults.array(forKey: "names") as! [String]
            let keys = self.appDelegate.userDefaults.array(forKey: "roleKeys") as! [Int]
            let values = self.appDelegate.userDefaults.array(forKey: "roleValues") as! [Int]
            if names.count >= 4 && keys.count == values.count {
                for name in names {
                    let player = Player(name: name)
                    self.appDelegate.playerList.append(player)
                }
                for index in 0..<keys.count {
                    self.appDelegate.prevRoleList[keys[index]] = values[index]
                }
                self.performSegue(withIdentifier: self.NEWGAME_SEGUE, sender: self)
            }else{
                self.showAlert(viewController: self, message: "セーブデータが壊れてます", buttonTitle: "OK")
            }
        }else{
            self.showAlert(viewController: self, message: "セーブデータがありません", buttonTitle: "OK")
        }
    }
}

