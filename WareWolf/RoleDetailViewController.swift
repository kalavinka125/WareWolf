//
//  RoleDetailViewController.swift
//  WareWolf
//
//  Created by falcon@mac on H29/11/21.
//  Copyright © 平成29年 NagaoLab. All rights reserved.
//

import UIKit

class RoleDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let CELL_ID = "ROLE_JOB_CELL"
    private let ROLE_CHECK_VC_ID = "RoleCheckViewController"
    private let SEGUE_NAME = "GO_TO_DISCUSSION"
    
    private var otherList : [Player] = []
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.imageView.image = UIImage(named: "\(self.appDelegate.playerList[self.appDelegate.playerID].role.ID)")
        self.roleLabel.text = self.appDelegate.playerList[self.appDelegate.playerID].role.name
        
        if self.appDelegate.playerList[self.appDelegate.playerID].role.side == .Villager {
            self.roleLabel.backgroundColor = self.appDelegate.villagerColor
            
        }else if self.appDelegate.playerList[self.appDelegate.playerID].role.side == .WereWolf {
            self.roleLabel.backgroundColor = self.appDelegate.wereWolfColor
            
        }else if self.appDelegate.playerList[self.appDelegate.playerID].role.side == .Fox {
            self.roleLabel.backgroundColor = self.appDelegate.foxColor
            
        }else {
            self.roleLabel.backgroundColor = UIColor.clear
            
        }
        
        self.detailLabel.text = self.appDelegate.playerList[self.appDelegate.playerID].role.detail
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 試しに1行
        return self.appDelegate.playerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.CELL_ID, for: indexPath) as! RoleJobTableViewCell
        if indexPath.row == self.appDelegate.playerID {
            cell.isHidden = true
        }else{
            cell.isHidden = false
        }
        cell.nameLabel.text = self.appDelegate.playerList[indexPath.row].name
        let role = self.appDelegate.playerList[self.appDelegate.playerID].role
        if role?.ID == 1{
            cell.jobButton.setTitle("殺害する", for: .normal)
        }else if role?.ID == 2 {
            cell.jobButton.setTitle("占う", for: .normal)
        }else if role?.ID == 4 {
            cell.jobButton.setTitle("守る", for: .normal)
        }else if role?.ID == 8 {
            cell.jobButton.setTitle("観る", for: .normal)
        }else if role?.ID == 13 {
            cell.jobButton.setTitle("守る", for: .normal)
        }else{
            cell.jobButton.setTitle("疑う", for: .normal)
        }
        
        // 生存,死亡判定
        if self.appDelegate.playerList[indexPath.row].isLife {
            cell.detailLabel.text = "死亡"
            cell.detailLabel.textColor = UIColor.red
            cell.jobButton.isHidden = true
        }else{
            cell.detailLabel.textColor = UIColor.black
            cell.jobButton.isHidden = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == self.appDelegate.playerID {
            return 0.0
        }
        return 74.0
    }
    
    @IBAction func tappedNextButton(_ sender: Any) {
        // 次のプレイヤーがいるか
        if self.appDelegate.playerID == (self.appDelegate.playerList.count - 1) {
            // 自分で最後、プレイヤーIDを0番に戻して、GO！
            self.appDelegate.playerID = 0
            // とりあえず議論へ
            self.performSegue(withIdentifier: self.SEGUE_NAME, sender: self)
            
        }else{
            // 次のプレイヤーがいるので、そちらへ遷移
            self.appDelegate.playerID += 1
            // 端末渡しの画面に遷移
            let next = self.storyboard?.instantiateViewController(withIdentifier: self.ROLE_CHECK_VC_ID) as! RoleCheckViewController
            next.modalTransitionStyle = .crossDissolve
            present(next, animated: true, completion: nil)
        }
    }
}