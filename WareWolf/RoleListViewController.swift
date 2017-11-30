//
//  RoleListViewController.swift
//  WareWolf
//
//  Created by falcon@mac on H29/11/19.
//  Copyright © 平成29年 NagaoLab. All rights reserved.
//

import UIKit

class RoleListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,RollTableViewCellDelegate {
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let ROLL_CELL = "ROLL_CELL"
    private let SEGUE_NAME = "GO_TO_CHECK"
    private let sections = [" 市民 "," 人狼 "," 狐 "," 探偵 "]
    
    var roleList : [Int : Int] = [:]
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // タイトルラベル
        self.titleLabel.text = "役職（\(self.appDelegate.playerList.count)名まで）"
        // デフォルト役職一覧を取得
        if self.roleList.count == 0 {
            self.roleList = self.appDelegate.roleManager.defaultRoleList(numberOfPlayer: self.appDelegate.playerList.count)
        }
        self.tableView.reloadData()
        self.showSelectRoles()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.SEGUE_NAME {
            let next = segue.destination as! CheckViewController
            next.roleList = self.roleList
        }
    }
    
    @IBAction func tappedRoleListButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedGameStartButton(_ sender: Any) {
        let member = self.getSelectRoles()
        // ゲームが開始できるかの判定
        if self.appDelegate.playerList.count == member {
            
            // 人狼がいるかどうか
            var w = 0
            if self.roleList[1] == nil {
                self.showAlert(viewController: self, message: "人狼がいません", buttonTitle: "OK")
                return
            }else{
                w = self.roleList[1]!
                if self.roleList[1]! < 1{
                    self.showAlert(viewController: self, message: "人狼がいません", buttonTitle: "OK")
                    return
                }
            }

            
            // 村人SIDE（今後は大狼も含む）のプレイヤーが１人以上
            var player = 0
            for role in self.appDelegate.roleList {
                /*
                // IDが1以外 かつ IDが18以上20以下でない
                if role.ID != 1 && !(role.ID >= 18 && role.ID <= 20) && self.roleList[role.ID] != nil {
                    player += self.roleList[role.ID]!
                }
                */
                if role.side == .Villager && self.roleList[role.ID] != nil && self.roleList[role.ID]! != 0{
                    player += self.roleList[role.ID]!
                }
            }
            if player <= 0 {
                self.showAlert(viewController: self, message: "市民がいません", buttonTitle: "OK")
                return
            }
            
            // 人狼以外のプレイヤー > 人狼
            if player <= w {
                self.showAlert(viewController: self, message: "人狼が市民の数以上います", buttonTitle: "OK")
                return
            }
            
            // 背徳者の判定
            // 背徳者がいるのに、狐がいない判定
            if self.roleList[20] != nil && self.roleList[20]! > 0 {
                if (self.roleList[18] == nil || self.roleList[18]! <= 0) && (self.roleList[19] == nil || self.roleList[19]! <= 0) {
                    self.showAlert(viewController: self, message: "背徳者がいますが、\n狐がいません", buttonTitle: "OK")
                    return
                }
            }
            
            // self.showAlert(viewController: self, message: "ゲームを開始します", buttonTitle: "OK")
            self.performSegue(withIdentifier: self.SEGUE_NAME, sender: self)
            
        }else{
            // プレイヤーの数が一致しなかった
            self.showAlert(viewController: self, message: "プレイヤー数が一致しません", buttonTitle: "OK")
            return
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    //この関数内でセクションの設定を行う
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        let font = UIFont(name: "PixelMplus10-Regular", size: 17.0)
        label.font = font
        label.textColor = UIColor.black
        label.text = self.sections[section]
        /*
         >> 人狼：223, 86, 86
         >> 村人：0, 223, 86
         >> 狐：240, 240, 86
        */
        if section == 0 {
            label.backgroundColor = UIColor.rgb(0, g: 223, b: 86, alpha: 1.0)
        }else if section == 1 {
            label.backgroundColor = UIColor.rgb(223, g: 86, b: 86, alpha: 1.0)
        }else if section == 2 {
            label.backgroundColor = UIColor.rgb(240, g: 240, b: 86, alpha: 1.0)
        }else if section == 3 {
            label.backgroundColor = self.appDelegate.detectiveColor
        }
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.appDelegate.villagerRoles.count
        }else if section == 1 {
            return self.appDelegate.wereWolfRoles.count
        }else if section == 2 {
            return self.appDelegate.foxRoles.count
        }else if section == 3 {
            return self.appDelegate.detectiveRoles.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.ROLL_CELL, for: indexPath) as! RollTableViewCell
        cell.numberOfRollLabel.text = "0"
        cell.indexPath = indexPath
        cell.delegate = self
        if indexPath.section == 0 {
            let villager = self.appDelegate.villagerRoles[indexPath.row]
            cell.nameLabel.text = villager.name
            cell.rollImageView.image = UIImage(named: "\(villager.ID)")!
            cell.detailLabel.text = villager.detail
            if let role = self.roleList[villager.ID] {
                cell.numberOfRollLabel.text = "\(role)"
            }
        }else if indexPath.section == 1 {
            let wereWolf = self.appDelegate.wereWolfRoles[indexPath.row]
            cell.nameLabel.text = wereWolf.name
            cell.rollImageView.image = UIImage(named: "\(wereWolf.ID)")
            cell.detailLabel.text = wereWolf.detail
            if let role = self.roleList[wereWolf.ID] {
                cell.numberOfRollLabel.text = "\(role)"
            }
        }else if indexPath.section == 2 {
            let fox = self.appDelegate.foxRoles[indexPath.row]
            cell.nameLabel.text = fox.name
            cell.rollImageView.image = UIImage(named: "\(fox.ID)")
            cell.detailLabel.text = fox.detail
            if let role = self.roleList[fox.ID] {
                cell.numberOfRollLabel.text = "\(role)"
            }
        }else if indexPath.section == 3 {
            let detective = self.appDelegate.detectiveRoles[indexPath.row]
            cell.nameLabel.text = detective.name
            cell.rollImageView.image = UIImage(named: "\(detective.ID)")
            cell.detailLabel.text = detective.detail
            if let role = self.roleList[detective.ID] {
                cell.numberOfRollLabel.text = "\(role)"
            }
        }
        return cell
    }
    
    func tappedPlusButton(indexPath: IndexPath) {
        var ID = -1
        if indexPath.section == 0 {
            // Villager
            ID = self.appDelegate.villagerRoles[indexPath.row].ID
        }else if indexPath.section == 1 {
            // WereWolf
            ID = self.appDelegate.wereWolfRoles[indexPath.row].ID
        }else if indexPath.section == 2 {
            // Fox
            ID = self.appDelegate.foxRoles[indexPath.row].ID
        }else if indexPath.section == 3 {
            // Detective
            ID = self.appDelegate.detectiveRoles[indexPath.row].ID
        }
        // もともと設定されていた人数を取得
        if let n = self.roleList[ID] {
            if ID == 9 {
                // self.roleList[ID] = (n + 2)
                return
            }else{
                // マジシャンと独裁者は１人まで
                if n >= 1 && ID == 15 {
                    return
                }else if n >= 1 && ID == 11 {
                    return 
                }else if n >= 1 && ID == 17 {
                    return
                }else{
                    self.roleList[ID] = (n + 1)
                }
            }
        }else{
            if ID == 9 {
                self.roleList[ID] = 2
            }else{
                // 新しく設定する必要あり
                self.roleList[ID] = 1
            }

        }
        self.tableView.beginUpdates()
        self.tableView.reloadRows(at: [indexPath], with: .none)
        self.tableView.endUpdates()
        self.showSelectRoles()
    }
    
    func tappedMinusButton(indexPath: IndexPath) {
        var ID = -1
        if indexPath.section == 0 {
            // Villager
            ID = self.appDelegate.villagerRoles[indexPath.row].ID
        }else if indexPath.section == 1 {
            // WereWolf
            ID = self.appDelegate.wereWolfRoles[indexPath.row].ID
        }else if indexPath.section == 2 {
            // Fox
            ID = self.appDelegate.foxRoles[indexPath.row].ID
        }else if indexPath.section == 3 {
            // Detective
            ID = self.appDelegate.detectiveRoles[indexPath.row].ID
        }
        // もともと設定されていた人数を取得
        if let n = self.roleList[ID] {
            if n > 0 {
                if ID == 9 {
                    self.roleList[ID] = (n - 2)
                }else{
                    self.roleList[ID] = (n - 1)
                }
            }
        }else{
            // 新しく設定する必要あり
            self.roleList[ID] = 0
        }
        self.tableView.beginUpdates()
        self.tableView.reloadRows(at: [indexPath], with: .none)
        self.tableView.endUpdates()
        self.showSelectRoles()
    }
    
    /// 選ばれている役職の数を取得する
    ///
    /// - Returns: 選ばれている役職数
    private func getSelectRoles() -> Int{
        var member = 0
        for (_, value) in self.roleList {
            member += value
        }
        return member
    }
    
    /// 選ばれている役職の数をラベルに表示する
    private func showSelectRoles() {
        self.titleLabel.text = "役職（\(self.getSelectRoles())名 / \(self.appDelegate.playerList.count)名）"
    }
    
}
