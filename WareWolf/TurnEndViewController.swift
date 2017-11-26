//
//  TurnEndViewController.swift
//  WareWolf
//
//  Created by falcon@mac on H29/11/26.
//  Copyright © 平成29年 NagaoLab. All rights reserved.
//

import UIKit

class TurnEndViewController: UIViewController {
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let NEXT_VC = "RoleCheckViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
