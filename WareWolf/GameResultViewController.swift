//
//  GameResultViewController.swift
//  WareWolf
//
//  Created by falcon@mac on H29/11/26.
//  Copyright © 平成29年 NagaoLab. All rights reserved.
//

import UIKit

class GameResultViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let CELL_ID = "GAME_ROLE_CELL"
    private let TOP_ID = "VIEW_CONTROLLER"
    var side : Side = .None
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var sideLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 0,1,19
        if self.side == .Villager {
            self.sideLabel.backgroundColor = self.appDelegate.villagerColor
            self.sideLabel.text = "市民サイド"
            self.imageView.image = UIImage(named: "0")!
            
            self.appDelegate.soundPlay(fileName: "win", numberOfLoop: 0)
        }else if self.side == .WereWolf {
            self.sideLabel.backgroundColor = self.appDelegate.wereWolfColor
            self.sideLabel.text = "人狼サイド"
            self.imageView.image = UIImage(named: "1")!
            self.appDelegate.soundPlay(fileName: "soundLogo", numberOfLoop: 0)
        }else if self.side == .Fox {
            self.sideLabel.backgroundColor = self.appDelegate.foxColor
            self.sideLabel.text = "　狐サイド"
            self.imageView.image = UIImage(named: "18")!
            self.appDelegate.soundPlay(fileName: "soundLogo", numberOfLoop: 0)
        }
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.appDelegate.playerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.CELL_ID, for: indexPath) as! GameRoleTableViewCell
        cell.nameLabel.text = self.appDelegate.playerList[indexPath.row].name
        cell.roleLabel.text = self.appDelegate.playerList[indexPath.row].role.name
        cell.roleImageView.image = UIImage(named: "\(self.appDelegate.playerList[indexPath.row].role.ID)")
        
        if self.side == self.appDelegate.playerList[indexPath.row].role.side {
            cell.resultImageView.isHidden = false
        }else{
            cell.resultImageView.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74.0
    }
    
    @IBAction func tappedEndButton(_ sender: Any) {
        let next = self.storyboard?.instantiateViewController(withIdentifier: self.TOP_ID) as! ViewController
        next.modalTransitionStyle = .crossDissolve
        present(next, animated: true, completion: nil)
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
