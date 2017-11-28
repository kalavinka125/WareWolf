//
//  RoleDetailViewController.swift
//  WareWolf
//
//  Created by falcon@mac on H29/11/21.
//  Copyright © 平成29年 NagaoLab. All rights reserved.
//

import UIKit

class RoleDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,RoleJobTableViewCellDelegate {
    var flag : RoleCheckVC = .check

    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let CELL_ID = "ROLE_JOB_CELL"
    private let ROLE_CHECK_VC_ID = "RoleCheckViewController"
    private let SEGUE_NAME = "GO_TO_INFO"
    private let PINK_COLOR = UIColor.rgb(255, g: 111, b: 207, alpha: 0.8)
    
    private var otherList : [Player] = []
    // 毎日のしごとをしたかどうか
    private var todayJob : Bool = false
    
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
        self.todayJob = false
        /*
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
        */
        self.updateRoleView()
        let player = self.appDelegate.playerList[self.appDelegate.playerID]
        // 初夜の場合、仕事は完了済みとする
        if self.appDelegate.turn <= 0 && (player.role.ID == 1 || player.role.ID == 4 || player.role.ID == 11 || player.role.ID == 13 || player.role.ID == 14 || player.role.ID == 16 || player.role.ID == 17) {
            self.todayJob = true
        }else if self.appDelegate.turn >= 1 && player.role.ID == 15{
            // 初夜以降、マジシャンは仕事できない
            self.todayJob = true
        }
        
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
        
        let role = self.appDelegate.playerList[self.appDelegate.playerID].role
        if role?.ID == 1{
            cell.jobButton.setTitle("殺害する", for: .normal)
            if self.appDelegate.wolfPointList[indexPath.row] != nil {
                cell.detailLabel.text = self.appDelegate.roleManager.generateWereWolfFlagTxt(wereWolf: self.appDelegate.wolfPointList[indexPath.row]!)
                if self.appDelegate.wolfPointList[indexPath.row]! > 0 {
                    cell.detailLabel.textColor = self.appDelegate.wereWolfColor
                }
            }
            // 自分が人狼で、表示するセルも人狼なら
            if self.appDelegate.playerList[indexPath.row].role.ID == 1 {
                cell.detailLabel.text = "人狼"
                cell.detailLabel.textColor = self.appDelegate.wereWolfColor
                cell.jobButton.isHidden = true
            }
        }else if role?.ID == 2 {
            cell.jobButton.setTitle("占う", for: .normal)
            if role?.uranaiResult[indexPath.row] != nil {
                if role?.uranaiResult[indexPath.row] == .Villager {
                    cell.detailLabel.text = "人間"
                    cell.detailLabel.textColor = self.appDelegate.villagerColor
                }else if role?.uranaiResult[indexPath.row] == .WereWolf {
                    cell.detailLabel.text = "人狼"
                    cell.detailLabel.textColor = self.appDelegate.wereWolfColor
                }else if role?.uranaiResult[indexPath.row] == .Fox {
                    cell.detailLabel.text = "狐"
                    cell.detailLabel.textColor = self.appDelegate.foxColor
                }
            }
        }else if role?.ID == 3 {
            // 霊媒師
            // 死んでいる人なら
            if !self.appDelegate.playerList[indexPath.row].isLife {
                let reibai = self.appDelegate.playerList[indexPath.row].role.reibai
                cell.detailLabel.text = "？？？"
                cell.detailLabel.textColor = UIColor.black
                if reibai == .Villager {
                    cell.detailLabel.text = "人間"
                    cell.detailLabel.textColor = self.appDelegate.villagerColor
                }else if reibai == .WereWolf {
                    cell.detailLabel.text = "人狼"
                    cell.detailLabel.textColor = self.appDelegate.wereWolfColor
                }else if reibai == .Fox {
                    cell.detailLabel.text = "狐"
                    cell.detailLabel.textColor = self.appDelegate.foxColor
                }
            }
            self.todayJob = true
        }else if role?.ID == 4 {
            cell.jobButton.setTitle("守る", for: .normal)
            if self.appDelegate.playerList[self.appDelegate.playerID].target == indexPath.row {
                cell.detailLabel.text = "守った"
                cell.detailLabel.textColor = self.appDelegate.villagerColor
            }
        }else if role?.ID == 7 {
            // 狂信者
            if self.appDelegate.playerList[indexPath.row].role.ID == 1 {
                cell.detailLabel.text = "人狼"
                cell.detailLabel.textColor = self.appDelegate.wereWolfColor
            }
            // 仕事は無い
            self.todayJob = true
        }else if role?.ID == 8 {
            cell.jobButton.setTitle("観る", for: .normal)
            if role?.uranaiResult[indexPath.row] != nil {
                if role?.uranaiResult[indexPath.row] == .Villager {
                    cell.detailLabel.text = "人間"
                    cell.detailLabel.textColor = self.appDelegate.villagerColor
                }else if role?.uranaiResult[indexPath.row] == .WereWolf {
                    cell.detailLabel.text = "人狼"
                    cell.detailLabel.textColor = self.appDelegate.wereWolfColor
                }else if role?.uranaiResult[indexPath.row] == .Fox {
                    cell.detailLabel.text = "狐"
                    cell.detailLabel.textColor = self.appDelegate.foxColor
                }
            }
        }else if role?.ID == 9 {
            if self.appDelegate.playerList[indexPath.row].role.ID == 9 {
                cell.detailLabel.text = "共有者"
                cell.detailLabel.textColor = self.appDelegate.villagerColor
            }
            // 仕事は無い
            self.todayJob = true
        }else if role?.ID == 13 {
            cell.jobButton.setTitle("守る", for: .normal)
            if self.appDelegate.playerList[self.appDelegate.playerID].target == indexPath.row {
                cell.detailLabel.text = "守った"
                cell.detailLabel.textColor = self.appDelegate.villagerColor
            }
        }else if role?.ID == 14 {
            cell.jobButton.setTitle("蘇生させる", for: .normal)
            if self.appDelegate.playerList[self.appDelegate.playerID].target == indexPath.row {
                cell.detailLabel.text = "蘇生済み"
                cell.detailLabel.textColor = self.appDelegate.villagerColor
            }

        }else if role?.ID == 15 {
            cell.jobButton.setTitle("交換する", for: .normal)
            if self.appDelegate.playerList[self.appDelegate.playerID].target == indexPath.row {
                if self.appDelegate.playerList[self.appDelegate.playerID].newRole != nil {
                    // 新しい役職に応じて、文字色変更
                    if self.appDelegate.playerList[self.appDelegate.playerID].newRole.side == .Villager {
                        cell.detailLabel.textColor = self.appDelegate.villagerColor
                    }else if self.appDelegate.playerList[self.appDelegate.playerID].newRole.side == .WereWolf {
                        cell.detailLabel.textColor = self.appDelegate.wereWolfColor
                    }else if self.appDelegate.playerList[self.appDelegate.playerID].newRole.side == .Fox {
                        cell.detailLabel.textColor = self.appDelegate.foxColor
                    }else {
                        cell.detailLabel.textColor = UIColor.black
                    }
                    // 「交換済み」を表示する
                    cell.detailLabel.text = "交換済み"
                }
            }
        }else if role?.ID == 16 {
            cell.jobButton.setTitle("識る", for: .normal)
            if self.appDelegate.playerList[self.appDelegate.playerID].target == indexPath.row {
                let satoriResult = self.appDelegate.playerList[self.appDelegate.playerID].role.satoriResult
                let satoriTarget = self.appDelegate.playerList[satoriResult]
                cell.detailLabel.text = "前回 "+satoriTarget.name + " に投票"
            }
        }else{
            cell.jobButton.isHidden = true
            self.todayJob = true
        }
        
        // 仕事済みだったら
        if self.todayJob {
            cell.jobButton.isHidden = true
        }
        
        // 蘇生させる系の役職の判定
        if role?.ID == 14 {
            // 死亡判定
            // 能力行使可能
            if !self.appDelegate.playerList[indexPath.row].isLife {

                if self.appDelegate.playerList[self.appDelegate.playerID].target == indexPath.row {
                    // 能力行使後
                    cell.jobButton.isHidden = true
                    cell.isUserInteractionEnabled = false
                }else{
                    // 能力行使前
                    cell.jobButton.isHidden = false
                    cell.isUserInteractionEnabled = true
                }
            }else{
                // 生きている場合
                cell.jobButton.isHidden = true
                cell.isUserInteractionEnabled = false
            }
        }else{
            // 死亡判定
            if !self.appDelegate.playerList[indexPath.row].isLife {
                cell.jobButton.isHidden = false
                cell.isUserInteractionEnabled = false
                cell.jobButton.backgroundColor = UIColor.lightGray
                cell.jobButton.setTitleColor(UIColor.black, for: .normal)
                cell.jobButton.setTitle("死亡", for: .normal)
            }
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
        let target = self.appDelegate.playerList[indexPath.row]
        let role = self.appDelegate.playerList[self.appDelegate.playerID].role
        // 1,2,4,8,13,15
        if role?.ID == 1 {
            // 能力ターゲットを記憶する
            self.appDelegate.playerList[self.appDelegate.playerID].target = indexPath.row
            
            // 人狼の処理
            let cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
            cancel.setValue(UIColor.black, forKey: "titleTextColor")
            
            let ok1 = UIAlertAction(title: "とりあえず殺す：1票", style: .default, handler: { okAction1 in
                DispatchQueue.main.async {
                    // 能力ターゲットを記憶する
                    self.appDelegate.playerList[self.appDelegate.playerID].target = indexPath.row
                    // target.role.wolfPoint += 1

                    if self.appDelegate.wolfPointList[indexPath.row] != nil {
                        self.appDelegate.wolfPointList[indexPath.row] = (self.appDelegate.wolfPointList[indexPath.row]! + 1)
                    }else{
                        self.appDelegate.wolfPointList[indexPath.row] = 1
                    }
                    if target.role.ID == 6 {
                        role?.deadEndFlag = true
                    }
                    self.todayJob = true
                    self.tableView.reloadData()
                }
            })
            let ok2 = UIAlertAction(title: "あえて殺す：2票", style: .default, handler: { okAction2 in
                DispatchQueue.main.async {
                    // 能力ターゲットを記憶する
                    self.appDelegate.playerList[self.appDelegate.playerID].target = indexPath.row
                    if self.appDelegate.wolfPointList[indexPath.row] != nil {
                        self.appDelegate.wolfPointList[indexPath.row] = (self.appDelegate.wolfPointList[indexPath.row]! + 2)
                    }else{
                        self.appDelegate.wolfPointList[indexPath.row] = 2
                    }
                    if target.role.ID == 6 {
                        role?.deadEndFlag = true
                    }
                    self.todayJob = true
                    self.tableView.reloadData()
                }
            })
            let ok3 = UIAlertAction(title: "絶対殺す：3票", style: .default, handler: { okAction3 in
                DispatchQueue.main.async {
                    // 能力ターゲットを記憶する
                    self.appDelegate.playerList[self.appDelegate.playerID].target = indexPath.row
                    //target.role.wolfPoint += 3
                    if self.appDelegate.wolfPointList[indexPath.row] != nil {
                        self.appDelegate.wolfPointList[indexPath.row] = (self.appDelegate.wolfPointList[indexPath.row]! + 3)
                    }else{
                        self.appDelegate.wolfPointList[indexPath.row] = 3
                    }
                    if target.role.ID == 6 {
                        role?.deadEndFlag = true
                    }
                    self.todayJob = true
                    self.tableView.reloadData()
                }
            })
            ok1.setValue(self.appDelegate.wereWolfColor, forKey: "titleTextColor")
            ok2.setValue(self.appDelegate.wereWolfColor, forKey: "titleTextColor")
            ok3.setValue(self.appDelegate.wereWolfColor, forKey: "titleTextColor")
            // アラートの設定
            let message = target.name + "を\n殺害しますか？"
            let alert: UIAlertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let font = UIFont(name: "PixelMplus10-Regular", size: 18)
            let messageFont : [String : AnyObject] = [NSFontAttributeName : font!]
            let attributedMessage = NSMutableAttributedString(string: message, attributes: messageFont)
            alert.setValue(attributedMessage, forKey: "attributedMessage")
            alert.addAction(cancel)
            alert.addAction(ok1)
            alert.addAction(ok2)
            alert.addAction(ok3)
            present(alert, animated: true, completion: nil)
        }else if role?.ID == 2 {
            // 占い師の処理
            self.appDelegate.playerList[self.appDelegate.playerID].target = indexPath.row
            
            let cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
            cancel.setValue(UIColor.black, forKey: "titleTextColor")
            let ok = UIAlertAction(title: "占う", style: .default, handler: { okAction in
                // 能力ターゲットを記憶する
                self.appDelegate.playerList[self.appDelegate.playerID].target = indexPath.row
                
                self.todayJob = true
                DispatchQueue.main.async {
                    if target.role.uranai == .Villager {
                        role?.uranaiResult[indexPath.row] = .Villager
                    }else if target.role.uranai == .WereWolf {
                        role?.uranaiResult[indexPath.row] = .WereWolf
                    }else if target.role.uranai == .Fox {
                        role?.uranaiResult[indexPath.row] = .Fox
                    }
                    // ターゲットがサイコキラーなら
                    if target.role.ID == 6 {
                        role?.deadEndFlag = true
                    }
                    // ターゲットが妖狐なら
                    else if target.role.ID == 18 {
                        target.role.deadEndFlag = true
                    }
                    self.tableView.reloadData()
                }
            })
            ok.setValue(self.appDelegate.villagerColor, forKey: "titleTextColor")
            let message = target.name + "を\n占いますか？"
            let alert: UIAlertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let font = UIFont(name: "PixelMplus10-Regular", size: 18)
            let messageFont : [String : AnyObject] = [NSFontAttributeName : font!]
            let attributedMessage = NSMutableAttributedString(string: message, attributes: messageFont)
            alert.setValue(attributedMessage, forKey: "attributedMessage")
            alert.addAction(cancel)
            alert.addAction(ok)
            // アラートの表示
            present(alert, animated: true, completion: nil)
        }else if role?.ID == 4 {
            // 騎士の処理
            self.appDelegate.playerList[self.appDelegate.playerID].target = indexPath.row
            
            let cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
            cancel.setValue(UIColor.black, forKey: "titleTextColor")
            let ok = UIAlertAction(title: "守る", style: .default, handler: { okAction in
                DispatchQueue.main.async {
                    // 能力ターゲットを記憶する
                    self.appDelegate.playerList[self.appDelegate.playerID].target = indexPath.row
                    self.todayJob = true
                    target.role.guardFlag = true
                    // サイコキラーの場合
                    if target.role.ID == 6 {
                        role?.deadEndFlag = true
                    }
                    self.tableView.reloadData()
                }
            })
            ok.setValue(self.appDelegate.villagerColor, forKey: "titleTextColor")
            let message = target.name + "を\n守りますか？"
            let alert: UIAlertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let font = UIFont(name: "PixelMplus10-Regular", size: 18)
            let messageFont : [String : AnyObject] = [NSFontAttributeName : font!]
            let attributedMessage = NSMutableAttributedString(string: message, attributes: messageFont)
            alert.setValue(attributedMessage, forKey: "attributedMessage")
            alert.addAction(cancel)
            alert.addAction(ok)
            // アラートの表示
            present(alert, animated: true, completion: nil)
        }else if role?.ID == 8 {
            // パパラッチの処理
            self.appDelegate.playerList[self.appDelegate.playerID].target = indexPath.row
            
            let cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
            cancel.setValue(UIColor.black, forKey: "titleTextColor")
            let ok = UIAlertAction(title: "観る", style: .default, handler: { okAction in
                // 能力ターゲットを記憶する
                self.appDelegate.playerList[self.appDelegate.playerID].target = indexPath.row
                
                self.todayJob = true
                DispatchQueue.main.async {
                    if target.role.uranai == .Villager {
                        role?.uranaiResult[indexPath.row] = .Villager
                        // ターゲットがサイコキラーなら
                        if target.role.ID == 6 {
                            role?.deadEndFlag = true
                        }
                    }else if target.role.uranai == .WereWolf {
                        role?.uranaiResult[indexPath.row] = .WereWolf
                    }else if target.role.uranai == .Fox {
                        role?.uranaiResult[indexPath.row] = .Fox
                        // ターゲットが妖狐なら
                        if target.role.ID == 18 {
                            target.role.deadEndFlag = true
                        }
                    }
                    self.tableView.reloadData()
                }
            })
            ok.setValue(self.appDelegate.wereWolfColor, forKey: "titleTextColor")
            let message = target.name + "を\n観ますか？"
            let alert: UIAlertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let font = UIFont(name: "PixelMplus10-Regular", size: 18)
            let messageFont : [String : AnyObject] = [NSFontAttributeName : font!]
            let attributedMessage = NSMutableAttributedString(string: message, attributes: messageFont)
            alert.setValue(attributedMessage, forKey: "attributedMessage")
            alert.addAction(cancel)
            alert.addAction(ok)
            // アラートの表示
            present(alert, animated: true, completion: nil)
        }else if role?.ID == 13 {
            // コスプレイヤー
            self.appDelegate.playerList[self.appDelegate.playerID].target = indexPath.row
            let cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
            cancel.setValue(UIColor.black, forKey: "titleTextColor")
            let ok = UIAlertAction(title: "守る", style: .default, handler: { okAction in
                DispatchQueue.main.async {
                    // 能力ターゲットを記憶する
                    self.appDelegate.playerList[self.appDelegate.playerID].target = indexPath.row
                    self.todayJob = true
                    target.role.guardFlag = true
                    // サイコキラーの場合
                    if target.role.ID == 6 {
                        role?.deadEndFlag = true
                    }
                    self.tableView.reloadData()
                }
            })
            ok.setValue(self.appDelegate.villagerColor, forKey: "titleTextColor")
            let message = target.name + "を\n守りますか？"
            let alert: UIAlertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let font = UIFont(name: "PixelMplus10-Regular", size: 18)
            let messageFont : [String : AnyObject] = [NSFontAttributeName : font!]
            let attributedMessage = NSMutableAttributedString(string: message, attributes: messageFont)
            alert.setValue(attributedMessage, forKey: "attributedMessage")
            alert.addAction(cancel)
            alert.addAction(ok)
            // アラートの表示
            present(alert, animated: true, completion: nil)
        }else if role?.ID == 14 {
            // ヒロイン
            self.appDelegate.playerList[self.appDelegate.playerID].target = indexPath.row
            let cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
            cancel.setValue(UIColor.black, forKey: "titleTextColor")
            let ok = UIAlertAction(title: "蘇生させる", style: .default, handler: { okAction in
                DispatchQueue.main.async {
                    // 能力ターゲットを記憶する
                    self.appDelegate.playerList[self.appDelegate.playerID].target = indexPath.row
                    self.todayJob = true
                    // ターゲットを復活させる
                    // target.isLife = true
                    if !self.appDelegate.rebornList.contains(indexPath.row) {
                        self.appDelegate.rebornList.append(indexPath.row)
                    }
                    // 自分に死亡フラグを立てる
                    role?.deadEndFlag = true
                    // 復活した人が出たことを表す
                    self.appDelegate.isReborn = true
                    self.tableView.reloadData()
                }
            })
            ok.setValue(self.appDelegate.villagerColor, forKey: "titleTextColor")
            let message = target.name + "を\n蘇生させますか？"
            let alert: UIAlertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let font = UIFont(name: "PixelMplus10-Regular", size: 18)
            let messageFont : [String : AnyObject] = [NSFontAttributeName : font!]
            let attributedMessage = NSMutableAttributedString(string: message, attributes: messageFont)
            alert.setValue(attributedMessage, forKey: "attributedMessage")
            alert.addAction(cancel)
            alert.addAction(ok)
            // アラートの表示
            present(alert, animated: true, completion: nil)
        }else if role?.ID == 15 {
            let message = target.name + "を\n交換しますか？"
            let alert: UIAlertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            // マジシャン
            let cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
            cancel.setValue(UIColor.black, forKey: "titleTextColor")
            let ok = UIAlertAction(title: "交換する", style: .default, handler: { okAction in
                DispatchQueue.main.async {
                    // 能力ターゲットを記憶する
                    self.appDelegate.playerList[self.appDelegate.playerID].target = indexPath.row
                    self.todayJob = true
                    // 交換対象のフラグをセット
                    target.isChange = true
                    target.prevRole = target.role
                    // 新しい役職
                    self.appDelegate.playerList[self.appDelegate.playerID].newRole = target.role
                    self.updateRoleView(role: target.role)
                    // サイコキラーの場合
                    if target.role.ID == 6 {
                        role?.deadEndFlag = true
                        // サイコキラーは交換できない
                        target.isChange = false
                    }
                    self.tableView.reloadData()
                }
            })
            ok.setValue(self.appDelegate.villagerColor, forKey: "titleTextColor")

            let font = UIFont(name: "PixelMplus10-Regular", size: 18)
            let messageFont : [String : AnyObject] = [NSFontAttributeName : font!]
            let attributedMessage = NSMutableAttributedString(string: message, attributes: messageFont)
            alert.setValue(attributedMessage, forKey: "attributedMessage")
            alert.addAction(cancel)
            alert.addAction(ok)
            // アラートの表示
            present(alert, animated: true, completion: nil)
        }else if role?.ID == 16 {
            // サトリ
            self.appDelegate.playerList[self.appDelegate.playerID].target = indexPath.row
            let cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
            cancel.setValue(UIColor.black, forKey: "titleTextColor")
            let ok = UIAlertAction(title: "識る", style: .default, handler: { okAction in
                DispatchQueue.main.async {
                    // 能力ターゲットを記憶する
                    self.appDelegate.playerList[self.appDelegate.playerID].target = indexPath.row
                    //
                    role?.satoriResult = target.voteTarget
                    self.todayJob = true
                    // サイコキラーの場合
                    if target.role.ID == 6 {
                        role?.deadEndFlag = true
                    }
                    self.tableView.reloadData()
                }
            })
            ok.setValue(self.appDelegate.villagerColor, forKey: "titleTextColor")
            let message = target.name + "を\n識りますか？"
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
    }
    
    @IBAction func tappedNextButton(_ sender: Any) {
        if self.todayJob {
            // 次のプレイヤーがいるか
            if self.appDelegate.playerID == (self.appDelegate.playerList.count - 1) {
                self.endRoleDetail()
            }else{
                // 次のプレイヤーがいるので、そちらへ遷移
                self.appDelegate.playerID += 1
                var endFlag = false
                for index in self.appDelegate.playerID..<self.appDelegate.playerList.count {
                    if self.appDelegate.playerList[index].isLife {
                        self.appDelegate.playerID = index
                        endFlag = true
                        break
                    }
                }
                if endFlag {
                    // 端末渡しの画面に遷移
                    let next = self.storyboard?.instantiateViewController(withIdentifier: self.ROLE_CHECK_VC_ID) as! RoleCheckViewController
                    next.modalTransitionStyle = .crossDissolve
                    next.flag = self.flag
                    present(next, animated: true, completion: nil)
                }else{
                    self.endRoleDetail()
                }
            }
            
        }else{
            self.showAlert(viewController: self, message: "今夜、何もしていません", buttonTitle: "ゲームに戻る")
        }
    }
    
    /// 役割画面のループを終わらせる処理
    private func endRoleDetail() {
        // 自分で最後、プレイヤーIDを0番に戻して、GO！
        self.appDelegate.playerID = 0
        // とりあえず議論へ
        self.performSegue(withIdentifier: self.SEGUE_NAME, sender: self)
    }
    
    /// 役職についての説明を表示するためのページ
    private func updateRoleView() {
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
    }
    
    private func updateRoleView(role : Role) {
        self.imageView.image = UIImage(named: "\(role.ID)")
        self.roleLabel.text = role.name
        
        if role.side == .Villager {
            self.roleLabel.backgroundColor = self.appDelegate.villagerColor
            
        }else if role.side == .WereWolf {
            self.roleLabel.backgroundColor = self.appDelegate.wereWolfColor
            
        }else if role.side == .Fox {
            self.roleLabel.backgroundColor = self.appDelegate.foxColor
            
        }else {
            self.roleLabel.backgroundColor = UIColor.clear
            
        }
        self.detailLabel.text = role.detail
    }
}
