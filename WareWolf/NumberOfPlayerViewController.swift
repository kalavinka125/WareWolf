//
//  NumberOfPlayerViewController.swift
//  WareWolf
//
//  Created by falcon@mac on H29/11/19.
//  Copyright © 平成29年 NagaoLab. All rights reserved.
//

import UIKit

class NumberOfPlayerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let PLAYER_CELL = "PLAYER_CELL"
    
    @IBOutlet weak var numberOfPlayersLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.numberOfPlayersLabel.text = "\(self.appDelegate.playerList.count)"
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tappedMinusButton(_ sender: Any) {
        // 減らす限界は4まで
        if self.appDelegate.playerList.count > 4 {
            // 末尾から削除
            self.appDelegate.playerList.removeLast()
        }
        self.numberOfPlayersLabel.text = "\(self.appDelegate.playerList.count)"
        self.tableView.reloadData()
    }
    
    @IBAction func tappedPlusButton(_ sender: Any) {
        // 増やす限界は20まで
        if self.appDelegate.playerList.count < 20 {
            let player = Role(name: "Player\(self.appDelegate.playerList.count+1)")
            self.appDelegate.playerList.append(player)
        }
        self.numberOfPlayersLabel.text = "\(self.appDelegate.playerList.count)"
        self.tableView.reloadData()
    }
    
    @IBAction func tappedTitleButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.PLAYER_CELL, for: indexPath) as! PlayerTableViewCell
        if (indexPath.row + 1) < 10 {
            cell.numberLabel.text = " \(indexPath.row + 1)."
        }else{
            cell.numberLabel.text = "\(indexPath.row + 1)."
        }
        cell.nameLabel.text = self.appDelegate.playerList[indexPath.row].name
        cell.nameLabel.adjustsFontSizeToFitWidth = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.appDelegate.playerList.count
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
