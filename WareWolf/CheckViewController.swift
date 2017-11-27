//
//  CheckViewController.swift
//  WareWolf
//
//  Created by falcon@mac on H29/11/21.
//  Copyright © 平成29年 NagaoLab. All rights reserved.
//

import UIKit

class CheckViewController: UIViewController {
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let SEGUE_NAME = "GO_TO_GAME"
    var villager = 0
    var wereWolf = 0
    var fox = 0
    var roleList : [Int:Int] = [:]
    
    @IBOutlet weak var villagerLabel: UILabel!
    @IBOutlet weak var wereWolfLabel: UILabel!
    @IBOutlet weak var foxLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for (key , value) in self.roleList {
            let role = self.appDelegate.roleManager.ID2Role(ID: key, roleList: self.appDelegate.roleList)
            if role != nil {
                if role!.side == .Villager {
                    self.villager += value
                }else if role!.side == .WereWolf {
                    self.wereWolf += value
                }else if role!.side == .Fox {
                    self.fox += value
                }
                // 選択中役職を入れていく
                for _ in 0..<value {
                    let tmpRole = Role(ID: (role?.ID)!, name: (role?.name)!, detail: (role?.detail)!, side: (role?.side)!, uranai: (role?.uranai)!, reibai: (role?.reibai)!)
                    self.appDelegate.joinRoleList.append(tmpRole)
                }
            }
        }
        
        self.villagerLabel.text = "市民サイド：" + self.showNumberOfRoleText(number: self.villager)
        self.wereWolfLabel.text = "人狼サイド：" + self.showNumberOfRoleText(number: self.wereWolf)
        self.foxLabel.text = "　狐サイド：" + self.showNumberOfRoleText(number: self.fox)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.SEGUE_NAME {
            let next = segue.destination as! RoleCheckViewController
            next.flag = .check
        }
    }
    
    @IBAction func tappedRoleButton(_ sender: Any) {
        self.appDelegate.joinRoleList = []
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedGameStartButton(_ sender: Any) {
        if self.appDelegate.joinRoleList.count > 0 {
            self.appDelegate.hintRoleList = self.roleList
            for index in 0..<self.appDelegate.playerList.count {
                let random = Int(arc4random_uniform(UInt32(self.appDelegate.joinRoleList.count)))
                // ランダムに役職を決定
                let role = self.appDelegate.joinRoleList[random]
                self.appDelegate.playerList[index].role = role
                // 削除
                self.appDelegate.joinRoleList.remove(at: random)
            }
            self.performSegue(withIdentifier: self.SEGUE_NAME, sender: self)
        }
    }
    
    /// 数字をいれると、「x名」
    ///
    /// - Parameter number: メンバー数
    /// - Returns: ラベル表示用のテキスト
    private func showNumberOfRoleText(number : Int) -> String{
        if number < 10 {
            return " \(number)名"
        }else{
            return "\(number)名"
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
