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
    private let sections = [" Villager "," WereWolf "," Fox "]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tappedRoleListButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
        if indexPath.section == 0 {
            let villager = self.appDelegate.villagerRoles[indexPath.row]
            cell.nameLabel.text = villager.name
            cell.rollImageView.image = UIImage(named: "\(villager.ID)")!
            cell.detailLabel.text = villager.detail
        }else if indexPath.section == 1 {
            let wereWolf = self.appDelegate.wereWolfRoles[indexPath.row]
            cell.nameLabel.text = wereWolf.name
            cell.rollImageView.image = UIImage(named: "\(wereWolf.ID)")
            cell.detailLabel.text = wereWolf.detail
        }else if indexPath.section == 2 {
            let fox = self.appDelegate.foxRoles[indexPath.row]
            cell.nameLabel.text = fox.name
            cell.rollImageView.image = UIImage(named: "\(fox.ID)")
            cell.detailLabel.text = fox.detail
        }
        return cell
    }
    
}
