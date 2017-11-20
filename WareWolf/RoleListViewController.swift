//
//  RoleListViewController.swift
//  WareWolf
//
//  Created by falcon@mac on H29/11/19.
//  Copyright © 平成29年 NagaoLab. All rights reserved.
//

import UIKit

class RoleListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let ROLL_CELL = "ROLL_CELL"
    private let SEGUE_NAME = "GO_TO_GAME"
    private let sections = [" Villager "," WereWolf "," Fox "]
    
    private var defaultRoleList : [Int : Int] = [:]
    
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
        self.defaultRoleList = self.appDelegate.roleManager.defaultRoleList(numberOfPlayer: self.appDelegate.playerList.count)
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tappedRoleListButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedGameStartButton(_ sender: Any) {
        // TODO : 人数 = メンバー
        // TODO : 人狼 > 0
        // TODO : 村人 + (狐 or 妖狐) > 0
        // TODO : 村人 + (狐 or 妖狐) > 人狼
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
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.ROLL_CELL, for: indexPath) as! RollTableViewCell
        cell.numberOfRollLabel.text = "0"
        if indexPath.section == 0 {
            let villager = self.appDelegate.villagerRoles[indexPath.row]
            cell.nameLabel.text = villager.name
            cell.rollImageView.image = UIImage(named: "\(villager.ID)")!
            cell.detailLabel.text = villager.detail
            if let role = self.defaultRoleList[villager.ID] {
                cell.numberOfRollLabel.text = "\(role)"
            }
        }else if indexPath.section == 1 {
            let wereWolf = self.appDelegate.wereWolfRoles[indexPath.row]
            cell.nameLabel.text = wereWolf.name
            cell.rollImageView.image = UIImage(named: "\(wereWolf.ID)")
            cell.detailLabel.text = wereWolf.detail
            if let role = self.defaultRoleList[wereWolf.ID] {
                cell.numberOfRollLabel.text = "\(role)"
            }
        }else if indexPath.section == 2 {
            let fox = self.appDelegate.foxRoles[indexPath.row]
            cell.nameLabel.text = fox.name
            cell.rollImageView.image = UIImage(named: "\(fox.ID)")
            cell.detailLabel.text = fox.detail
            if let role = self.defaultRoleList[fox.ID] {
                cell.numberOfRollLabel.text = "\(role)"
            }
        }
        return cell
    }
    
}
