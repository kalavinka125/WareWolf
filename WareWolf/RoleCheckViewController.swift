//
//  RoleCheckViewController.swift
//  WareWolf
//
//  Created by falcon@mac on H29/11/20.
//  Copyright © 平成29年 NagaoLab. All rights reserved.
//

import UIKit

enum RoleCheckVC {
    case none
    case check
    case vote
}

class RoleCheckViewController: UIViewController {
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    private let RESULT_SEGUE = "GO_TO_ROLE_RESULT"
    private let VOTE_SEGUE = "GO_TO_VOTE"
    private let flag : RoleCheckVC = .check
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.nameLabel.adjustsFontSizeToFitWidth = true
        self.nameLabel.text = self.appDelegate.playerList[self.appDelegate.playerID].name
        if flag == .check {
            self.button.setTitle("確認", for: .normal)
        }else if flag == .vote{
            self.button.setTitle("投票", for: .normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tappedCheckButton(_ sender: Any) {
        if flag == .check {
            self.performSegue(withIdentifier: self.RESULT_SEGUE, sender: self)
        }else if flag == .vote {
            self.performSegue(withIdentifier: self.VOTE_SEGUE, sender: self)
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
