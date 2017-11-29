//
//  DictatorListViewController.swift
//  WareWolf
//
//  Created by falcon@mac on H29/11/29.
//  Copyright © 平成29年 NagaoLab. All rights reserved.
//

import UIKit

class DictatorListViewController: UIViewController {
    private var isJob = false
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let CELL_ID = "ROLE_DICTATOR_CELL"
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func tappedNextButton(_ sender: Any) {
        if self.isJob {
            
        }else{
            self.showAlert(viewController: self, message: "追放者を決めていません", buttonTitle: "OK")
        }
    }
}
