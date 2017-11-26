//
//  VoteViewController.swift
//  WareWolf
//
//  Created by falcon@mac on H29/11/24.
//  Copyright © 平成29年 NagaoLab. All rights reserved.
//

import UIKit

class VoteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, RoleJobTableViewCellDelegate {
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let CELL_ID = "ROLE_VOTE_CELL"
    private let NEXT_VC_ID = "RoleCheckViewController"
    private let VOTE_TOP = "VOTE_TOP_VC"
    private let VOTE_RESUL_SEGUE = "GO_VOTE_RESULT"
    
    private var voteTarget = -1
    private var isJob = false
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        self.isJob = false
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.VOTE_RESUL_SEGUE {
            let next = segue.destination as! VoteResultViewController
            next.voteTarget = self.voteTarget
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.appDelegate.playerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.CELL_ID, for: indexPath) as! RoleJobTableViewCell
        let player = self.appDelegate.playerList[self.appDelegate.playerID]
        let role = self.appDelegate.playerList[self.appDelegate.playerID].role
        let target = self.appDelegate.playerList[indexPath.row]
        cell.indexPath = indexPath
        cell.delegate = self
        if indexPath.row == self.appDelegate.playerID {
            cell.isHidden = true
        }else{
            cell.isHidden = false
        }
        
        if self.isJob {
            cell.jobButton.isHidden = true
        }else{
            cell.jobButton.isHidden = false
        }
        // 投票ターゲット = 表示行
        if player.voteTarget == indexPath.row {
            cell.detailLabel.textColor = self.appDelegate.wereWolfColor
            cell.detailLabel.text = "投票した"
        }else{
            cell.detailLabel.textColor = UIColor.black
            cell.detailLabel.text = "？？？"
        }
        
        if role?.ID == 1 {
            
        }
        
        cell.nameLabel.text = self.appDelegate.playerList[indexPath.row].name
        if self.appDelegate.playerList[indexPath.row].isLife {
            cell.jobButton.backgroundColor = self.appDelegate.wereWolfColor
            cell.jobButton.setTitleColor(UIColor.white, for: .normal)
            cell.jobButton.setTitle("投票", for: .normal)
        }else{
            cell.isUserInteractionEnabled = false
            cell.jobButton.isHidden = false
            cell.jobButton.backgroundColor = UIColor.lightGray
            cell.jobButton.setTitleColor(UIColor.black, for: .normal)
            cell.jobButton.setTitle("死亡", for: .normal)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == self.appDelegate.playerID {
            return 0.0
        }
        return 74.0
    }
    
    func tappedRoleJobButton(indexPath: IndexPath) {
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        cancel.setValue(UIColor.black, forKey: "titleTextColor")
        let ok = UIAlertAction(title: "投票する", style: .default, handler: { okAction in
            DispatchQueue.main.async {
                // 投票ターゲットを記憶する
                self.isJob = true
                self.appDelegate.playerList[self.appDelegate.playerID].voteTarget = indexPath.row
                if self.appDelegate.votePointList[indexPath.row] == nil {
                    self.appDelegate.votePointList[indexPath.row] = 1
                }else{
                    self.appDelegate.votePointList[indexPath.row] = self.appDelegate.votePointList[indexPath.row]! + 1
                }
                self.tableView.reloadData()
            }
        })
        ok.setValue(self.appDelegate.wereWolfColor, forKey: "titleTextColor")
        let message = self.appDelegate.playerList[indexPath.row].name + "に\n投票しますか？"
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
            // 終了条件
            if self.appDelegate.playerID == (self.appDelegate.playerList.count - 1) {
                // nilのところを0に
                for (key,_) in self.appDelegate.votePointList {
                    if self.appDelegate.votePointList[key] == nil {
                        self.appDelegate.votePointList[key] = 0
                    }
                }
                var isAllOne = false
                for (_,value) in self.appDelegate.votePointList {
                    if value == 1 {
                        isAllOne = true
                    }else{
                        isAllOne = false
                        break
                    }
                }
                // print(self.appDelegate.votePointList)
                
                // 全員の投票数が1
                if isAllOne {
                    self.appDelegate.playerID = 0
                    // 投票のやり直し
                    self.appDelegate.votePointList = [:]
                    let next = self.storyboard?.instantiateViewController(withIdentifier: self.VOTE_TOP) as! VoteTopViewController
                    next.modalTransitionStyle = .crossDissolve
                    next.flag = .retry
                    // 投票ターゲットを初期化
                    for player in self.appDelegate.playerList {
                        player.voteTarget = -1
                    }
                    present(next, animated: true, completion: nil)
                }
                
                var maxValue = 0
                var maxKey = 0
                var keys : [Int] = []
                for (key , value) in self.appDelegate.votePointList {
                    // 最大値を求める
                    if value > maxValue {
                        maxValue = value
                        maxKey = key
                    }
                }
                keys.append(maxKey)
                for (key , value) in self.appDelegate.votePointList {
                    if value == maxValue && maxKey != key {
                        keys.append(key)
                    }
                }
                // １人より多く居た場合
                if keys.count > 1 {
                    // TODO:決戦投票
                }else{
                    self.voteTarget = maxKey
                    // ターンを増やす
                    self.appDelegate.turn += 1
                    self.performSegue(withIdentifier: self.VOTE_RESUL_SEGUE, sender: self)
                }
                
                // 最後の画面に遷移する
                /*
                let next = self.storyboard?.instantiateViewController(withIdentifier: self.NEXT_VC_ID) as! RoleCheckViewController
                next.flag = .check
                next.modalTransitionStyle = .crossDissolve
                */
            }else{
                self.appDelegate.playerID += 1
                // ネクスト生存プレイヤーに渡す
                for index in self.appDelegate.playerID..<self.appDelegate.playerList.count {
                    if self.appDelegate.playerList[index].isLife{
                        self.appDelegate.playerID = index
                        break
                    }
                }
                self.dismiss(animated: true, completion: nil)
            }
        }else{
            self.showAlert(viewController: self, message: "今夜、何もしていません", buttonTitle: "ゲームに戻る")
        }
    }
}
