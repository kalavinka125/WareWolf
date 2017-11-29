//
//  RoleCheckInDiscussionViewController.swift
//  WareWolf
//
//  Created by falcon@mac on H29/11/29.
//  Copyright © 平成29年 NagaoLab. All rights reserved.
//

import UIKit

class RoleCheckInDiscussionViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    private let DICTATOR_SEGUE = "GO_TO_DICTATOR"
    private let DETECTIVE_SEGUE = "GO_TO_DETECTIVE"
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var selectRow = -1
    private let font = UIFont(name: "PixelMplus10-Regular", size: 24)

    var prev : RoleCheckinDiscussion = .none
    
    @IBOutlet weak var checkRoleLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.prev == .detective{
            self.checkRoleLabel.text = "本当に、名探偵ですか？"
        }else if self.prev == .dictator {
            self.checkRoleLabel.text = "本当に、独裁者ですか？"
        }
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.pickerView.reloadAllComponents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.appDelegate.playerList.count
    }
    
    /*
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if self.appDelegate.playerList[row].isLife {
            return self.appDelegate.playerList[row].name
        }else{
            return self.appDelegate.playerList[row].name + "（死亡）"
        }
    }
    */
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 64.0
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.pickerView.frame.size.width, height: self.pickerView.frame.size.height))
        label.font = font
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        if self.appDelegate.playerList[row].isLife {
            label.textColor = self.appDelegate.villagerColor
            label.text = self.appDelegate.playerList[row].name
        }else{
            label.textColor = self.appDelegate.wereWolfColor
            label.text = self.appDelegate.playerList[row].name + "（死亡）"
        }
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // 選択中の行数を取得
        self.selectRow = row
    }
    
    @IBAction func tappedBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func tappedCheckButton(_ sender: Any) {
        //let message = self.checkRoleLabel.text!
        //let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if self.selectRow != -1 {
            if self.appDelegate.playerList[self.selectRow].isLife {
                /*
                let font = UIFont(name: "PixelMplus10-Regular", size: 18)
                let messageFont : [String : AnyObject] = [NSFontAttributeName : font!]
                let attributedMessage = NSMutableAttributedString(string: message, attributes: messageFont)
                alert.setValue(attributedMessage, forKey: "attributedMessage")
                let action : UIAlertAction = UIAlertAction(title: "確認する", style: .default, handler: { okAction in
                    DispatchQueue.main.async {

                    }
                })
                action.setValue(UIColor.black, forKey: "titleTextColor")
                let cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
                cancel.setValue(UIColor.black, forKey: "titleTextColor")
                alert.addAction(cancel)
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
                */
                if self.prev == .dictator {
                    // 独裁者
                    if self.appDelegate.playerList[self.selectRow].role.ID == 11 {
                        self.appDelegate.dictatorID = self.selectRow
                        self.performSegue(withIdentifier: self.DICTATOR_SEGUE, sender: self)
                    }else{
                        self.showAlert(viewController: self, message: "あなたは、\n独裁者ではありません", buttonTitle: "OK")
                    }
                }else if self.prev == .detective {
                    // 探偵
                    if self.appDelegate.playerList[self.selectRow].role.ID == 17 {
                        self.appDelegate.detectiveID = self.selectRow
                        self.performSegue(withIdentifier: self.DETECTIVE_SEGUE, sender: self)
                    }else{
                        self.showAlert(viewController: self, message: "あなたは、\n名探偵ではありません", buttonTitle: "OK")
                    }
                }
            }else{
                self.showAlert(viewController: self, message: "死亡したプレイヤーです", buttonTitle: "OK")
            }
        }else{
            self.showAlert(viewController: self, message: "入力エラー", buttonTitle: "OK")
        }
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
