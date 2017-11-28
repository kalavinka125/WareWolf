//
//  TurnEndViewController.swift
//  WareWolf
//
//  Created by falcon@mac on H29/11/26.
//  Copyright © 平成29年 NagaoLab. All rights reserved.
//

import UIKit

class TurnEndViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource {
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let NEXT_VC = "RoleCheckViewController"
    private let CELL_ID = "PLAYER_LIFE_CELL"
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tappedNextButton(_ sender: Any) {
        let next = self.storyboard?.instantiateViewController(withIdentifier: self.NEXT_VC) as! RoleCheckViewController
        next.modalTransitionStyle = .crossDissolve
        next.flag = .none
        // 生きているプレイヤーに回す
        for index in 0..<self.appDelegate.playerList.count {
            // 生存
            if self.appDelegate.playerList[index].isLife {
                self.appDelegate.playerID = index
                break
            }
        }
        present(next, animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.appDelegate.playerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.CELL_ID, for: indexPath) as! PlayerLifeTableViewCell
        cell.nameLabel.text = self.appDelegate.playerList[indexPath.row].name
        if (indexPath.row + 1) < 10 {
            cell.numberLabel.text = " \(indexPath.row + 1)."
        }else{
            cell.numberLabel.text = "\(indexPath.row + 1)."
        }
        if self.appDelegate.playerList[indexPath.row].isLife {
            cell.statusLabel.text = "生存"
            cell.statusLabel.textColor = self.appDelegate.villagerColor
        }else{
            cell.statusLabel.text = "死亡"
            cell.statusLabel.textColor = self.appDelegate.wereWolfColor
        }
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
