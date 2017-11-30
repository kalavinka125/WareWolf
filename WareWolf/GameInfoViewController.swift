//
//  GameInfoViewController.swift
//  WareWolf
//
//  Created by falcon@mac on H29/11/30.
//  Copyright © 平成29年 NagaoLab. All rights reserved.
//

import UIKit

class GameInfoViewController: UIViewController , UITableViewDelegate,UITableViewDataSource{
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let LIFE_CELL = "PLAYER_LIFE_CELL"
    private let HINT_CELL = "ROLE_HINT_CELL"
    
    private var keys : [Int] = []
    private var roleList : [Int:Int] = [:]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // テーブルに空白は表示させない
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.roleList = [:]
        
        // プレイヤーリストから役職一覧を生成
        for player in self.appDelegate.playerList {
            if self.roleList[player.role.ID] == nil {
                self.roleList[player.role.ID] = 1
            }else{
                self.roleList[player.role.ID] = self.roleList[player.role.ID]! + 1
            }
        }
        self.keys = self.roleList.keys.sorted()
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.appDelegate.playerList.count
        }else if section == 1 {
            return self.roleList.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.LIFE_CELL, for: indexPath) as! PlayerLifeTableViewCell
            if (indexPath.row + 1) < 10 {
                cell.numberLabel.text = " \(indexPath.row + 1)."

            }else{
                cell.numberLabel.text = "\(indexPath.row + 1)."

            }
            cell.nameLabel.text = self.appDelegate.playerList[indexPath.row].name
            if self.appDelegate.playerList[indexPath.row].isLife {
                cell.statusLabel.text = "生存"
                cell.statusLabel.textColor = self.appDelegate.villagerColor
            }else{
                cell.statusLabel.text = "死亡"
                cell.statusLabel.textColor = self.appDelegate.wereWolfColor
            }
            return cell
        }else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.HINT_CELL, for: indexPath) as! RoleHintTableViewCell
            let role = self.appDelegate.roleManager.ID2Role(ID: self.keys[indexPath.row], roleList: self.appDelegate.roleList)
            cell.roleImageView.image = UIImage(named: String(role!.ID))!
            cell.nameLabel.text = (role?.name)! + "：\(self.roleList[self.keys[indexPath.row]]!)名"
            if role?.side == .Villager {
                cell.sideLabel.textColor = self.appDelegate.villagerColor
                cell.sideLabel.text = "市民"
            }else if role?.side == .WereWolf{
                cell.sideLabel.textColor = self.appDelegate.wereWolfColor
                cell.sideLabel.text = "人狼"
            }else if role?.side == .Fox {
                cell.sideLabel.textColor = self.appDelegate.foxColor
                cell.sideLabel.text = "　狐"
            }else if role?.side == .Detective {
                cell.sideLabel.textColor = self.appDelegate.detectiveColor
                cell.sideLabel.text = "探偵"
            }
            return cell
        }
        return UITableViewCell()
    }
    
    //この関数内でセクションの設定を行う
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        let font = UIFont(name: "PixelMplus10-Regular", size: 17.0)
        label.font = font
        label.textColor = UIColor.black
        label.backgroundColor = UIColor.rgb(255, g: 111, b: 207, alpha: 1.0)
        
        if section == 0 {
            label.text = "プレイヤー数：\(self.appDelegate.playerList.count)名"
        }else if section == 1 {
            label.text = "参加している役職"
        }
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32.0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 44.0
        }else if indexPath.section == 1 {
            return 64.0
        }
        return 0.0
    }
    
    @IBAction func tappedBackButton(_ sender: Any) {
        // 戻る
        self.dismiss(animated: true, completion: nil)
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
