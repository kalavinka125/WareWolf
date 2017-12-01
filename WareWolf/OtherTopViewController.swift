//
//  OtherTopViewController.swift
//  WareWolf
//
//  Created by falcon@mac on H29/12/01.
//  Copyright © 平成29年 NagaoLab. All rights reserved.
//

import UIKit

class OtherTopViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    private let list = ["ゲームのルール","役職について","オプション","クレジット","このアプリについて"]
    private let CELL_ID = "OTHER_CELL"
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.CELL_ID, for: indexPath) as! PlayerTableViewCell
        cell.numberLabel.text = "□"
        cell.nameLabel.text = list[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
        }else if indexPath.row == 1 {
            
        }else if indexPath.row == 2 {
            self.showAlert(viewController: self, message: "設定できるオプションは\n現在ありません", buttonTitle: "OK")
        }else if indexPath.row == 3 {
        }else if indexPath.row == 4 {
            
        }
    }
    
    @IBAction func tappedBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
