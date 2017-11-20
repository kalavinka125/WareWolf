//
//  RoleListViewController.swift
//  WareWolf
//
//  Created by falcon@mac on H29/11/19.
//  Copyright © 平成29年 NagaoLab. All rights reserved.
//

import UIKit

class RoleListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    private let ROLL_CELL = "ROLL_CELL"
    private let sections = [" WareWolf "," Fox "," Villager "]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tappedRoleListButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    //この関数内でセクションの設定を行う
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        let font = UIFont(name: "PixelMplus10-Regular", size: 17.0)
        label.font = font
        label.textColor = UIColor.black
        label.text = self.sections[section]
        /*
         >> 人狼：223, 86, 86
         >> 狐：240, 240, 86
         >> 村人：0, 223, 86
        */
        if section == 0 {
            label.backgroundColor = UIColor.rgb(223, g: 86, b: 86, alpha: 1.0)
        }else if section == 1 {
            label.backgroundColor = UIColor.rgb(240, g: 240, b: 86, alpha: 1.0)
        }else if section == 2 {
            label.backgroundColor = UIColor.rgb(0, g: 223, b: 86, alpha: 1.0)
        }
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 5
        }else if section == 1 {
            return 2
        }else if section == 2 {
            return 13
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.ROLL_CELL, for: indexPath) as! RollTableViewCell
        return cell
    }
    
}
