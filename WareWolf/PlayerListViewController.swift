//
//  PlayerListViewController.swift
//  WareWolf
//
//  Created by falcon@mac on H29/11/20.
//  Copyright © 平成29年 NagaoLab. All rights reserved.
//

import UIKit

class PlayerListViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,PlayerEditTableViewCellDelegate {
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let CELL_ID = "PLAER_EDIT"
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
        // 編集モード
        self.tableView.isEditing = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tappedNumberOfPlayersButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.CELL_ID, for: indexPath) as! PlayerEditTableViewCell
        cell.nameLabel.text = self.appDelegate.playerList[indexPath.row].name
        cell.nameLabel.adjustsFontSizeToFitWidth = true
        cell.row = indexPath.row
        cell.delegate = self
        if (indexPath.row+1) < 10{
            cell.numberLabel.text = " \(indexPath.row+1)."
        }else{
            cell.numberLabel.text = "\(indexPath.row+1)."
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.appDelegate.playerList.count
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let target = self.appDelegate.playerList[sourceIndexPath.row]
        self.appDelegate.playerList.remove(at: sourceIndexPath.row)
        self.appDelegate.playerList.insert(target, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if self.appDelegate.playerList.count > 4 {
            self.appDelegate.playerList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.appDelegate.playerList[textField.tag].name = textField.text!
        textField.resignFirstResponder()
        return true
    }
    
    func tappedChangeButton(row: Int) {
        let alert = UIAlertController(title: nil, message: "", preferredStyle: .alert)
        let font = UIFont(name: "PixelMplus10-Regular", size: 18)
        let messageFont : [String : AnyObject] = [NSFontAttributeName : font!]
        let attributedMessage = NSMutableAttributedString(string: "名前の変更", attributes: messageFont)
        alert.setValue(attributedMessage, forKey: "attributedMessage")
        // アクションの設定
        let action = UIAlertAction(title: "保存", style: .default, handler: { alertAction in
            if let textFields = alert.textFields {
                if let textField = textFields.last {
                    // テキストフィールドが存在する時
                    self.appDelegate.playerList[row].name = textField.text!
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        })
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: { cancelAction in })
        action.setValue(UIColor.black, forKey: "titleTextColor")
        cancel.setValue(UIColor.black, forKey: "titleTextColor")
        alert.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
            textField.font = font
            textField.text = self.appDelegate.playerList[row].name
            textField.tag = row
        })
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
}
