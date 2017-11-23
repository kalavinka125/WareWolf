//
//  InfoViewController.swift
//  WareWolf
//
//  Created by falcon@mac on H29/11/24.
//  Copyright © 平成29年 NagaoLab. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let SEGUE_NAME = "GO_TO_DISCUSSION"
    private let CELL_ID = "VICTIM_CELL"
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var victimLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doubtLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "\(self.appDelegate.turn)日目 の 朝です"
        // TODO:被害者の判定
        let doubtIndex = self.appDelegate.roleManager.getDoubtTopPlayer(players: self.appDelegate.playerList)
        print(doubtIndex)
        if doubtIndex == -1 {
            self.doubtLabel.textColor = self.appDelegate.villagerColor
            self.doubtLabel.text = "---"
        }else{
            self.doubtLabel.textColor = self.appDelegate.wereWolfColor
            self.doubtLabel.text = self.appDelegate.playerList[doubtIndex].name
        }
    }
    
    @IBAction func tappedDiscussionStartButton(_ sender: Any) {
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