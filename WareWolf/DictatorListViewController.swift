//
//  DictatorListViewController.swift
//  WareWolf
//
//  Created by falcon@mac on H29/11/29.
//  Copyright © 平成29年 NagaoLab. All rights reserved.
//

import UIKit

class DictatorListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, RoleJobTableViewCellDelegate {
    private var isJob = false
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let CELL_ID = "ROLE_DICTATOR_CELL"
    
    private let TURNEND_VC_ID = "TURN_END_VC"
    private let GAMEOVER_VC_ID = "GameResultViewController"
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.appDelegate.playerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.CELL_ID, for: indexPath) as! RoleJobTableViewCell
        cell.indexPath = indexPath
        cell.delegate = self
        
        cell.nameLabel.text = self.appDelegate.playerList[indexPath.row].name
        cell.detailLabel.textColor = UIColor.black
        cell.detailLabel.text = "？？？"
        cell.jobButton.isHidden = false
        cell.jobButton.isUserInteractionEnabled = true
        cell.jobButton.backgroundColor = self.appDelegate.wereWolfColor
        cell.jobButton.setTitleColor(UIColor.white, for: .normal)
        
        if indexPath.row == self.appDelegate.playerID {
            cell.isHidden = true
        }else{
            cell.isHidden = false
        }
        
        // 仕事済みだったら
        if self.isJob {
            cell.jobButton.isHidden = true
        }
        
        // 死亡判定
        if !self.appDelegate.playerList[indexPath.row].isLife {
            cell.jobButton.isHidden = false
            cell.isUserInteractionEnabled = false
            cell.jobButton.backgroundColor = UIColor.lightGray
            cell.jobButton.setTitleColor(UIColor.black, for: .normal)
            cell.jobButton.setTitle("死亡", for: .normal)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == self.appDelegate.dictatorID {
            return 0.0
        }else{
            return 74.0
        }
    }
    
    func tappedRoleJobButton(indexPath: IndexPath) {
        
    }
    
    @IBAction func tappedNextButton(_ sender: Any) {
        if self.isJob {
            //
            
            // 独裁者IDを-1に
            self.appDelegate.dictatorID = -1
        }else{
            self.showAlert(viewController: self, message: "追放者を決めていません", buttonTitle: "OK")
        }
    }
}
