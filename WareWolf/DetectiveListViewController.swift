//
//  DetectiveListViewController.swift
//  WareWolf
//
//  Created by falcon@mac on H29/11/30.
//  Copyright © 平成29年 NagaoLab. All rights reserved.
//

import UIKit

class DetectiveListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource ,RoleJobTableViewCellDelegate,UIPickerViewDelegate,UIPickerViewDataSource{
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let GAMEOVER_VC_ID = "GameResultViewController"
    private let DISCUSSION_VC_ID = "DiscussionViewController"
    private let GO_TO_RESULT = "DETECTIVE_RESULT"
    private let CELL_ID = "DETECTIVE_CELL"
    private let font = UIFont(name: "PixelMplus10-Regular", size: 24)
    
    private var toolbar : UIToolbar!
    private var pickerView : UIPickerView!
    private var selectRow = -1
    private var selectIndexPath : IndexPath!
    private var roles : [Role] = []
    private var detectiveList : [Int : String] = [:]
    private var alert : UIAlertController!
    
    var isSuccess = false
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.toolbar = UIToolbar(frame: CGRect(x: 0, y: self.view.bounds.size.height/6, width: self.view.bounds.size.width, height: 40.0))
        self.toolbar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        self.toolbar.barStyle = .blackTranslucent
        self.toolbar.tintColor = UIColor.white
        self.toolbar.backgroundColor = self.appDelegate.villagerColor
        let doneBarButton = UIBarButtonItem(title: "当てる", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.tappedDoneToolbarButton))
        self.toolbar.items = [doneBarButton]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.roles = []
        self.detectiveList = [:]
        var isVillager = false
        for (key,_) in self.appDelegate.hintRoleList {
            // 名探偵以外を追加
            if key != 17 {
                let role = self.appDelegate.roleManager.ID2Role(ID: key, roleList: self.appDelegate.roleList)
                self.roles.append(role!)
                if key == 0 {
                    // 市民がいるなら
                    isVillager = true
                }
            }
        }
        // 市民の選択肢が無かったときに、市民の選択肢を追加
        if !isVillager {
            let role = self.appDelegate.roleManager.ID2Role(ID: 0, roleList: self.appDelegate.roleList)
            self.roles.append(role!)
        }
        self.pickerView = UIPickerView()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.pickerView.reloadAllComponents()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.GO_TO_RESULT {
            let next = segue.destination as! DetectiveResultViewController
            next.isSuccess = self.isSuccess
            // BGM停止
            self.appDelegate.soundPlayer.stop()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.appDelegate.playerList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == self.appDelegate.detectiveID {
            return 0.0
        }else{
            return 74.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.CELL_ID, for: indexPath) as! RoleJobTableViewCell
        cell.indexPath = indexPath
        cell.delegate = self
        cell.nameLabel.text = self.appDelegate.playerList[indexPath.row].name
        cell.nameLabel.adjustsFontSizeToFitWidth = true
        cell.detailLabel.textColor = UIColor.black
        cell.detailLabel.text = "？？？"
        cell.detailLabel.adjustsFontSizeToFitWidth = true
        cell.jobButton.isHidden = false
        cell.jobButton.isUserInteractionEnabled = true
        cell.jobButton.backgroundColor = self.appDelegate.wereWolfColor
        cell.jobButton.setTitleColor(UIColor.white, for: .normal)
        
        if indexPath.row == self.appDelegate.detectiveID {
            cell.isHidden = true
        }else{
            cell.isHidden = false
        }
        
        if self.appDelegate.playerList[indexPath.row].isLife {
            cell.jobButton.backgroundColor = self.appDelegate.wereWolfColor
            cell.jobButton.setTitleColor(UIColor.white, for: .normal)
            cell.jobButton.setTitle("当てる", for: .normal)
        }else{
            cell.jobButton.isUserInteractionEnabled = false
            cell.jobButton.isHidden = false
            cell.jobButton.backgroundColor = UIColor.lightGray
            cell.jobButton.setTitleColor(UIColor.black, for: .normal)
            cell.jobButton.setTitle("死亡", for: .normal)
        }
        
        if self.detectiveList[indexPath.row] != nil {
            // 推理中の役職名
            let name = self.detectiveList[indexPath.row]
            cell.detailLabel.text = name
        }
        
        return cell
    }
    
    func tappedRoleJobButton(indexPath: IndexPath) {
        self.selectIndexPath = indexPath
        self.alert = UIAlertController(title: nil, message: "", preferredStyle: .alert)
        let font = UIFont(name: "PixelMplus10-Regular", size: 18)
        let messageFont : [String : AnyObject] = [NSFontAttributeName : font!]
        let attributedMessage = NSMutableAttributedString(string: "役職の指名", attributes: messageFont)
        self.alert.setValue(attributedMessage, forKey: "attributedMessage")
        // アクションの設定
        let action = UIAlertAction(title: "当てる", style: .default, handler: { alertAction in
            if let textFields = self.alert.textFields {
                if let textField = textFields.last {
                    // テキストフィールドが存在する時
                    // self.appDelegate.playerList[row].name = textField.text!
                    DispatchQueue.main.async {
                        if self.selectRow < 0 {
                            self.selectRow = 0
                        }
                        textField.text = self.roles[self.selectRow].name
                        self.detectiveList[indexPath.row] = self.roles[self.selectRow].name
                        self.tableView.reloadData()
                    }
                }
            }
        })
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: { cancelAction in })
        action.setValue(UIColor.black, forKey: "titleTextColor")
        cancel.setValue(UIColor.black, forKey: "titleTextColor")
        self.alert.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
            textField.font = font
            textField.tag = indexPath.row
            textField.inputView = self.pickerView
            // textField.inputAccessoryView = self.toolbar
            
        })
        self.alert.addAction(action)
        self.alert.addAction(cancel)
        present(self.alert, animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.roles.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 64.0
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: self.pickerView.frame.size.width, height: self.pickerView.frame.size.height))
        label.font = font
        label.adjustsFontSizeToFitWidth = true
        label.text = self.roles[row].name
        label.textAlignment = .center
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectRow = row
        self.alert.textFields?.last!.text = self.roles[self.selectRow].name
    }
    
    @IBAction func tappedNextButton(_ sender: Any) {
        
        // 生存者の数と入力された役職
        let lifeList = self.appDelegate.roleManager.getList(target: true, players: self.appDelegate.playerList)
        if (lifeList.count - 1) == self.detectiveList.count {
            let message = "答え合わせしますか？"
            let answerAlert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let font = UIFont(name: "PixelMplus10-Regular", size: 18)
            let messageFont : [String : AnyObject] = [NSFontAttributeName : font!]
            let attributedMessage = NSMutableAttributedString(string: message, attributes: messageFont)
            answerAlert.setValue(attributedMessage, forKey: "attributedMessage")
            let action : UIAlertAction = UIAlertAction(title: "はい", style: .default, handler: { okAction in
                // 答え合わせ
                for (key , value) in self.detectiveList {
                    // PlayerID : RoleID
                    if self.appDelegate.playerList[key].role.name == value {
                        self.isSuccess = true
                    }else{
                        self.isSuccess = false
                        break
                    }
                }
                /*
                answerAlert.dismiss(animated: true, completion: {
                })
                */
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: self.GO_TO_RESULT, sender: self)
                }
            })
            action.setValue(self.appDelegate.detectiveColor, forKey: "titleTextColor")
            let cancel = UIAlertAction(title: "いいえ", style: .cancel, handler: nil)
            cancel.setValue(UIColor.black, forKey: "titleTextColor")
            answerAlert.addAction(cancel)
            answerAlert.addAction(action)
            present(answerAlert, animated: true, completion: nil)
            
        }else{
            self.showAlert(viewController: self, message: "全員の役職を\n推理して下さい", buttonTitle: "OK")
        }

    }
    
    func tappedDoneToolbarButton(sender: UIBarButtonItem){
        if self.selectRow < 0 {
            self.selectRow = 0
        }
        self.alert.textFields?.last!.text = self.roles[self.selectRow].name
        self.detectiveList[self.selectIndexPath.row] = self.roles[self.selectRow].name
        self.alert.dismiss(animated: true, completion: {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
}
