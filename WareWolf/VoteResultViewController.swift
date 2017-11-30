//
//  VoteResultViewController.swift
//  WareWolf
//
//  Created by falcon@mac on H29/11/26.
//  Copyright © 平成29年 NagaoLab. All rights reserved.
//

import UIKit

enum VoteResult {
    case normal
    case dictator
}

class VoteResultViewController: UIViewController {
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let NIGHT_SEGUE = "GO_GAME_NIGHT"
    private let RESULT_SEGUE = "GO_GAME_RESULT"
    
    private var side : Side = .None
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    var voteTarget = -1
    var prev : VoteResult = .normal
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.prev == .normal {
            self.titleLabel.text = "投票の結果\n処刑されるのは"
        }else if self.prev == .dictator {
            self.titleLabel.text = "独裁者が決断しました\n処刑されるのは"
        }
        
        // 投票で選ばれた人物を処刑
        self.appDelegate.playerList[self.voteTarget].isLife = false
        self.nameLabel.text = self.appDelegate.playerList[self.voteTarget].name
        // self.appDelegate.soundPlay(fileName: "buki", numberOfLoop: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.RESULT_SEGUE {
            let next = segue.destination as! GameResultViewController
            next.side = self.side
        }
    }
    
    @IBAction func tappedNextButton(_ sender: Any) {
        self.side = self.appDelegate.roleManager.isGameOver(players: self.appDelegate.playerList)
        self.nextPage()
        if self.side == .None {
            // 猫又の場合
            if self.appDelegate.playerList[self.voteTarget].role.ID == 10 {
                // 猫又の結果
                let nekomata = self.appDelegate.roleManager.nekomata(players: self.appDelegate.playerList)
                self.side = nekomata
                if nekomata == .None{
                    self.performSegue(withIdentifier: self.NIGHT_SEGUE, sender: self)
                }else{
                    self.performSegue(withIdentifier: self.RESULT_SEGUE, sender: self)
                }
            }else{
                self.performSegue(withIdentifier: self.NIGHT_SEGUE, sender: self)
            }
        }else{
            // ゲームの勝敗が決まっているので、リザルトへ
            self.performSegue(withIdentifier: self.RESULT_SEGUE, sender: self)
        }
    }
    
    private func nextPage() {
        self.appDelegate.turn += 1
        // 再生中なら停止
        if self.appDelegate.soundPlayer.isPlaying {
            self.appDelegate.soundPlayer.stop()
        }
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
