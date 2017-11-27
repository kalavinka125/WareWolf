//
//  InfoViewController.swift
//  WareWolf
//
//  Created by falcon@mac on H29/11/24.
//  Copyright © 平成29年 NagaoLab. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let SEGUE_NAME = "GO_TO_DISCUSSION"
    private let CELL_ID = "VICTIM_CELL"
    private let GAME_RESULT_VC = "GameResultViewController"
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var victimLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    // @IBOutlet weak var doubtLabel: UILabel!
    
    private var victimList : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // self.title = "\(self.appDelegate.turn)日目 の 朝です"
        self.timeLabel.text = "\(self.appDelegate.turn+1)日目 の 朝です"
        self.victimList = []
        let victimIDList = self.appDelegate.roleManager.getVictimList(players: self.appDelegate.playerList, wereWolfPointTable: self.appDelegate.wolfPointList, turn: self.appDelegate.turn)
        
        // 1日目の夜は限定
        if self.appDelegate.turn <= 0 {
            // マジシャンの交換処理を行う
            for player in self.appDelegate.playerList {
                // 新しい役職を持っている = マジシャン（or 怪盗）
                if player.newRole != nil {
                    player.prevRole = player.role
                    player.role = player.newRole
                }
                // 交換対象
                if player.isChange {
                    // 交換された人物は「市民」になる
                    let base = self.appDelegate.roleManager.ID2Role(ID: 0, roleList: self.appDelegate.roleList)
                    let simin = Role(ID: (base?.ID)!, name: (base?.name)!, detail: (base?.detail)!, side: (base?.side)!, uranai: (base?.uranai)!, reibai: (base?.reibai)!)
                    // 市民に変更
                    player.role = simin
                    player.isChange = false
                }
            }
        }
        for vID in victimIDList {
            // 死亡判定に変更
            self.appDelegate.playerList[vID].isLife = false
            self.victimList.append(self.appDelegate.playerList[vID].name)
        }
        // 犠牲者が１人でも居た場合
        if victimIDList.count > 0 {
            self.victimLabel.textColor = self.appDelegate.wereWolfColor
            self.victimLabel.text = "本日、犠牲者が \(self.victimList.count)名 出ました"
        }else{
            self.victimLabel.textColor = UIColor.black
            self.victimLabel.text = "本日、犠牲者は出ませんでした"
        }
        self.tableView.reloadData()
        // 人狼ポイントテーブルの初期化
        self.appDelegate.wolfPointList = [:]
        /*
        let doubtIndex = self.appDelegate.roleManager.getDoubtTopPlayer(players: self.appDelegate.playerList)
        if doubtIndex == -1 {
            self.doubtLabel.textColor = self.appDelegate.villagerColor
            self.doubtLabel.text = "---"
        }else{
            self.doubtLabel.textColor = self.appDelegate.wereWolfColor
            self.doubtLabel.text = self.appDelegate.playerList[doubtIndex].name
        }
        */
        // 疑わしい人のリセット
        // 全員の死亡フラグを元に戻す
        // 全員の騎士フラグを元に戻す
        for player in self.appDelegate.playerList {
            // player.doubt = 0
            player.role.guardFlag = false
            player.role.deadEndFlag = false
        }
        // サウンドロゴを流す
        self.appDelegate.soundPlay(fileName: "bird6", numberOfLoop: -1)
    }
    
    @IBAction func tappedDiscussionStartButton(_ sender: Any) {
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        cancel.setValue(UIColor.black, forKey: "titleTextColor")
        let ok = UIAlertAction(title: "はい", style: .default, handler: { okAction in
            let side = self.appDelegate.roleManager.isGameOver(players: self.appDelegate.playerList)
            if side == .None {
                if self.appDelegate.soundPlayer.isPlaying {
                    self.appDelegate.soundPlayer.stop()
                }
                self.performSegue(withIdentifier: self.SEGUE_NAME, sender: self)
            }else{
                let next = self.storyboard?.instantiateViewController(withIdentifier: self.GAME_RESULT_VC) as! GameResultViewController
                next.side = side
                next.modalTransitionStyle = .flipHorizontal
                self.present(next, animated: true, completion: nil)
            }
        })
        ok.setValue(self.appDelegate.wereWolfColor, forKey: "titleTextColor")
        
        let message = "議論を開始しますか？"
        let alert: UIAlertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let font = UIFont(name: "PixelMplus10-Regular", size: 18)
        let messageFont : [String : AnyObject] = [NSFontAttributeName : font!]
        let attributedMessage = NSMutableAttributedString(string: message, attributes: messageFont)
        alert.setValue(attributedMessage, forKey: "attributedMessage")
        alert.addAction(cancel)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.victimList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.CELL_ID, for: indexPath) as! VictimTableViewCell
        if (indexPath.row + 1) < 10 {
            cell.numberLabel.text = " \(indexPath.row + 1)."
        }else{
            cell.numberLabel.text = "\(indexPath.row + 1)."
        }
        cell.nameLabel.text = self.victimList[indexPath.row]
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
