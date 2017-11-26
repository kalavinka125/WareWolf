//
//  VoteTopViewController.swift
//  WareWolf
//
//  Created by falcon@mac on H29/11/24.
//  Copyright © 平成29年 NagaoLab. All rights reserved.
//

import UIKit

enum VoteFlag {
    case normal
    case retry
    case battle
}

class VoteTopViewController: UIViewController {
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let NEXT_VC = "RoleCheckViewController"
    
    var flag : VoteFlag = .normal
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.flag == .retry {
            self.showAlert(viewController: self, message: "処刑する人物を\n1名決めてください", buttonTitle: "OK")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tappedStartButton(_ sender: Any) {
        let next = self.storyboard?.instantiateViewController(withIdentifier: self.NEXT_VC) as! RoleCheckViewController
        next.modalTransitionStyle = .crossDissolve
        next.flag = .vote
        // ネクスト生存プレイヤーに渡す
        for index in 0..<self.appDelegate.playerList.count {
            if self.appDelegate.playerList[index].isLife{
                self.appDelegate.playerID = index
                break
            }
        }
        self.present(next, animated: true, completion: nil)
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
