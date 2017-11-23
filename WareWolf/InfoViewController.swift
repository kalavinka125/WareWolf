//
//  InfoViewController.swift
//  WareWolf
//
//  Created by falcon@mac on H29/11/24.
//  Copyright © 平成29年 NagaoLab. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    private let SEGUE_NAME = "GO_TO_DISCUSSION"
    private let CELL_ID = "VICTIM_CELL"
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var victimLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doubtLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
