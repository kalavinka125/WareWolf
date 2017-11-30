//
//  DetectiveResultViewController.swift
//  WareWolf
//
//  Created by falcon@mac on H29/11/30.
//  Copyright © 平成29年 NagaoLab. All rights reserved.
//

import UIKit

class DetectiveResultViewController: UIViewController {

    var isSuccess = false
    private let DISCUSSION_VC_ID = "DiscussionViewController"
    private let GAMEOVER_VC_ID = "GameResultViewController"
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let maru = UIImage(named: "maru")!
    private let batsu = UIImage(named: "batsu")!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var detailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.isSuccess {
            self.titleLabel.text = "推理成功！"
            self.imageView.image = maru
            self.detailLabel.textColor = self.appDelegate.detectiveColor
            self.detailLabel.text = "推理に成功したので、\n名探偵の勝利です"
        }else{
            self.titleLabel.text = "推理失敗！"
            self.imageView.image = batsu
            self.detailLabel.textColor = self.appDelegate.wereWolfColor
            self.detailLabel.text = "推理に失敗したので、\n名探偵は死亡します"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tappedNextButton(_ sender: Any) {
        if self.isSuccess {
            // 推理成功
            let next = self.storyboard?.instantiateViewController(withIdentifier: self.GAMEOVER_VC_ID) as! GameResultViewController
            next.side = .Detective
            next.modalTransitionStyle = .crossDissolve
            present(next, animated: true, completion: nil)
        }else{
            // 探偵役職は死亡
            self.appDelegate.playerList[self.appDelegate.detectiveID].isLife = false
            // 議論画面に遷移させる
            let next = self.storyboard?.instantiateViewController(withIdentifier: self.DISCUSSION_VC_ID) as! DiscussionViewController
            next.modalTransitionStyle = .crossDissolve
            present(next, animated: true, completion: nil)
        }
    }
}
