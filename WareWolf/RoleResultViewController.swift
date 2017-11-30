//
//  RoleResultViewController.swift
//  WareWolf
//
//  Created by falcon@mac on H29/11/20.
//  Copyright © 平成29年 NagaoLab. All rights reserved.
//

import UIKit

class RoleResultViewController: UIViewController {
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let SEGUE_NAME = "GO_TO_ROLEDETAIL"
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var sideLabel: UILabel!
    
    var flag : RoleCheckVC = .none
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.SEGUE_NAME {
            let next = segue.destination as! RoleDetailViewController
            next.flag = self.flag
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.roleLabel.text = self.appDelegate.playerList[self.appDelegate.playerID].role.name
        self.imageView.image = UIImage(named: "\(self.appDelegate.playerList[self.appDelegate.playerID].role.ID)")
        self.sideLabel.textColor = UIColor.black
        /*
         >> 村人：0, 223, 86
         >> 人狼：223, 86, 86
         >> 狐：240, 240, 86
        */
        if self.appDelegate.playerList[self.appDelegate.playerID].role.side == .Villager {
            self.roleLabel.backgroundColor = UIColor.rgb(0, g: 223, b: 86, alpha: 1.0)
            self.sideLabel.textColor = UIColor.rgb(0, g: 223, b: 86, alpha: 1.0)
            self.sideLabel.text = "市民サイド"
        }else if self.appDelegate.playerList[self.appDelegate.playerID].role.side == .WereWolf {
            self.roleLabel.backgroundColor = UIColor.rgb(223, g: 86, b: 86, alpha: 1.0)
            self.sideLabel.textColor = UIColor.rgb(223, g: 86, b: 86, alpha: 1.0)
            self.sideLabel.text = "人狼サイド"
        }else if self.appDelegate.playerList[self.appDelegate.playerID].role.side == .Fox {
            self.roleLabel.backgroundColor = UIColor.rgb(240, g: 240, b: 86, alpha: 1.0)
            self.sideLabel.textColor = UIColor.rgb(240, g: 240, b: 86, alpha: 1.0)
            self.sideLabel.text = "狐サイド"
        }else if self.appDelegate.playerList[self.appDelegate.playerID].role.side == .Detective {
            self.roleLabel.backgroundColor = self.appDelegate.detectiveColor
            self.sideLabel.textColor = self.appDelegate.detectiveColor
            self.sideLabel.text = "探偵サイド"
        }
    }
    
    @IBAction func tappedOKButton(_ sender: Any) {
        self.performSegue(withIdentifier: self.SEGUE_NAME, sender: self)
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
