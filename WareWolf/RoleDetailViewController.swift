//
//  RoleDetailViewController.swift
//  WareWolf
//
//  Created by falcon@mac on H29/11/21.
//  Copyright © 平成29年 NagaoLab. All rights reserved.
//

import UIKit

class RoleDetailViewController: UIViewController {
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    private let CELL_ID = "ROLE_JOB_CELL"
    private let ROLE_CHECK_VC_ID = "RoleCheckViewController"
    private let SEGUE_NAME = "GO_TO_DISCUSSION"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tappedNextButton(_ sender: Any) {
        // 次のプレイヤーがいるか
        if self.appDelegate.playerID == (self.appDelegate.playerList.count - 1) {
            // 自分で最後、プレイヤーIDを0番に戻して、GO！
            self.appDelegate.playerID = 0
            // とりあえず議論へ
            self.performSegue(withIdentifier: self.SEGUE_NAME, sender: self)
            
        }else{
            // 次のプレイヤーがいるので、そちらへ遷移
            self.appDelegate.playerID += 1
            // 端末渡しの画面に遷移
            let next = self.storyboard?.instantiateViewController(withIdentifier: self.ROLE_CHECK_VC_ID) as! RoleCheckViewController
            next.modalTransitionStyle = .crossDissolve
            present(next, animated: true, completion: nil)
        }
    }
}
