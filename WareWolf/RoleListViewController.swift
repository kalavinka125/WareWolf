//
//  RoleListViewController.swift
//  WareWolf
//
//  Created by falcon@mac on H29/11/19.
//  Copyright © 平成29年 NagaoLab. All rights reserved.
//

import UIKit

class RoleListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tappedRoleListButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
