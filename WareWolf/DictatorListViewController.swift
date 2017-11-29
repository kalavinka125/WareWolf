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
    
    private var voteTarget = -1
    // private let TURNEND_VC_ID = "TURN_END_VC"
    private let VOTE_RESULT_VC_ID = "VOTE_RESULT_VC"
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

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
        
        if indexPath.row == self.appDelegate.dictatorID {
            cell.isHidden = true
        }else{
            cell.isHidden = false
        }
        
        if self.appDelegate.playerList[self.appDelegate.dictatorID].target == indexPath.row {
            cell.detailLabel.text = "追放した"
            cell.detailLabel.textColor = self.appDelegate.villagerColor
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
        let target = self.appDelegate.playerList[indexPath.row]
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        cancel.setValue(UIColor.black, forKey: "titleTextColor")
        let ok = UIAlertAction(title: "追放する", style: .default, handler: { okAction in
            DispatchQueue.main.async {
                // 能力ターゲットを記憶する
                self.appDelegate.playerList[self.appDelegate.dictatorID].target = indexPath.row
                // 投票ターゲット扱い
                self.voteTarget = indexPath.row
                // 仕事を行なった
                self.isJob = true
                self.tableView.reloadData()
            }
        })
        ok.setValue(self.appDelegate.villagerColor, forKey: "titleTextColor")
        let message = target.name + "を\n追放しますか？"
        let alert: UIAlertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let font = UIFont(name: "PixelMplus10-Regular", size: 18)
        let messageFont : [String : AnyObject] = [NSFontAttributeName : font!]
        let attributedMessage = NSMutableAttributedString(string: message, attributes: messageFont)
        alert.setValue(attributedMessage, forKey: "attributedMessage")
        alert.addAction(cancel)
        alert.addAction(ok)
        // アラートの表示
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func tappedNextButton(_ sender: Any) {
        if self.isJob {
            // 独裁者IDを-1に
            self.appDelegate.dictatorID = -1
            // 投票完了画面に遷移
            let next = self.storyboard?.instantiateViewController(withIdentifier: self.VOTE_RESULT_VC_ID) as! VoteResultViewController
            next.modalTransitionStyle = .crossDissolve
            next.voteTarget = self.voteTarget
            present(next, animated: true, completion: nil)
        }else{
            self.showAlert(viewController: self, message: "追放者を決めていません", buttonTitle: "OK")
        }
    }
}
