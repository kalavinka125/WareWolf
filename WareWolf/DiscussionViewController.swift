//
//  DiscussionViewController.swift
//  WareWolf
//
//  Created by falcon@mac on H29/11/21.
//  Copyright © 平成29年 NagaoLab. All rights reserved.
//

import UIKit

enum RoleCheckinDiscussion {
    case none
    case dictator
    case detective
}

/// 議論中の画面
class DiscussionViewController: UIViewController {
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var lifeList : [Int] = []
    private let NEXT_VC = "RoleCheckViewController"
    private let SEGUE_NAME = "GO_TO_VOTE_TOP"
    private let ROLE_CHECK_SEGUE = "ROLE_CHECK_IN_DISCUSSION"
    // private let DICTATOR_SEGUE = "GO_TO_DICTATOR"
    var time = 0
    var isLimit = false
    // タイマー
    var timer : Timer!
    // 実行セグエ管理
    var segue : RoleCheckinDiscussion = .none
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 生存者を取得
        self.lifeList = self.appDelegate.roleManager.getList(target: true, players: self.appDelegate.playerList)
        
        if self.time == 0 {
            // 生存者の数に合わせて、議論時間を変える
            if self.lifeList.count >= 5 {
                self.time = (60 * 5)
            }else{
                self.time = (60 * self.lifeList.count)
            }
            self.timeLabel.textColor = UIColor.black
            self.timeLabel.text = self.time2Text(time: self.time)
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
            self.appDelegate.soundPlay(fileName: "bgm1", numberOfLoop: -1)
        }else{
            self.timeLabel.textColor = UIColor.black
            self.timeLabel.text = self.time2Text(time: self.time)
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
            self.appDelegate.soundPlay(fileName: "bgm1", numberOfLoop: -1)
        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.SEGUE_NAME {
            let next = segue.destination as! VoteTopViewController
            next.flag = .normal
        }else if segue.identifier == self.ROLE_CHECK_SEGUE {
            let next = segue.destination as! RoleCheckInDiscussionViewController
            next.prev = self.segue
        }
    }
    
    @IBAction func tappedPlusTimeButton(_ sender: Any) {
        self.isLimit = false
        self.time += 60
        self.timeLabel.textColor = UIColor.black
        self.timeLabel.text = self.time2Text(time: self.time)
        
        /*
        if self.appDelegate.soundPlayer.isPlaying{
            // 停止
            self.appDelegate.soundPlayer.stop()
            // BGM再開
            self.appDelegate.soundPlay(fileName: "bgm1", numberOfLoop: -1)
        }
        */
        // BGM停止中
        if self.appDelegate.isPause {
            self.appDelegate.isPause = false
            self.appDelegate.soundPlayer.stop()
            self.appDelegate.soundPlay(fileName: "bgm1", numberOfLoop: -1)
        }
    }

    @IBAction func tappedDiscussionButton(_ sender: Any) {
        let message = "投票に移りますか？"
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let font = UIFont(name: "PixelMplus10-Regular", size: 18)
        let messageFont : [String : AnyObject] = [NSFontAttributeName : font!]
        let attributedMessage = NSMutableAttributedString(string: message, attributes: messageFont)
        alert.setValue(attributedMessage, forKey: "attributedMessage")
        let action : UIAlertAction = UIAlertAction(title: "はい", style: .default, handler: { okAction in
            DispatchQueue.main.async {
                // BGMの再生を停止する
                self.appDelegate.soundPlayer.stop()
                self.appDelegate.isPause = false
                // タイマーの停止
                self.timer.invalidate()
                self.timer = nil
                self.time = 0
                /*
                if self.appDelegate.dictatorID == -1 {
                    self.performSegue(withIdentifier: self.SEGUE_NAME, sender: self)
                }else{
                    self.performSegue(withIdentifier: self.DICTATOR_SEGUE, sender: self)
                }
                */
                self.performSegue(withIdentifier: self.SEGUE_NAME, sender: self)
            }
        })
        action.setValue(UIColor.black, forKey: "titleTextColor")
        let cancel = UIAlertAction(title: "いいえ", style: .cancel, handler: nil)
        cancel.setValue(UIColor.black, forKey: "titleTextColor")
        alert.addAction(cancel)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func tappedDictationButton(_ sender: Any) {
        if self.appDelegate.hintRoleList[11] != nil && self.appDelegate.hintRoleList[11]! > 0 {
            if self.appDelegate.dictatorID == -1 {
                self.segue = .dictator
                self.timer.invalidate()
                self.appDelegate.soundPlayer.stop()
                self.appDelegate.isPause = false
                // 1秒以下なら60秒足す
                if self.time <= 1 {
                    self.isLimit = false
                    self.time += 60
                    self.timeLabel.textColor = UIColor.black
                    self.timeLabel.text = self.time2Text(time: self.time)
                }
                self.performSegue(withIdentifier: self.ROLE_CHECK_SEGUE, sender: self)
            }else{
                self.showAlert(viewController: self, message: "独裁者は\n既に能力を使いました", buttonTitle: "OK")
            }
        }else{
            self.showAlert(viewController: self, message: "今回の参加者に\n独裁者はいません", buttonTitle: "OK")
        }
    }
    
    @IBAction func tappedDetectiveButton(_ sender: Any) {
        if self.appDelegate.hintRoleList[17] != nil && self.appDelegate.hintRoleList[17]! > 0 {
            if self.appDelegate.detectiveID == -1 {
                self.segue = .detective
                self.timer.invalidate()
                self.appDelegate.soundPlayer.stop()
                self.appDelegate.isPause = false
                // 1秒以下なら60秒足す
                if self.time <= 1 {
                    self.isLimit = false
                    self.time += 60
                    self.timeLabel.textColor = UIColor.black
                    self.timeLabel.text = self.time2Text(time: self.time)
                }
                self.performSegue(withIdentifier: self.ROLE_CHECK_SEGUE, sender: self)
            }else{
                self.showAlert(viewController: self, message: "名探偵は\n既に能力を使いました", buttonTitle: "OK")
            }
        }else{
            self.showAlert(viewController: self, message: "今回の参加者に\n名探偵はいません", buttonTitle: "OK")
        }
    }
    
    func update(timer : Timer) {
        if self.time > 0 {
            self.time -= 1
            self.timeLabel.textColor = UIColor.black
        }else{
            if !self.isLimit {
                self.isLimit = true
                self.appDelegate.soundPlayer.stop()
                self.appDelegate.isPause = true
                self.appDelegate.soundPlay(fileName: "kaneOto", numberOfLoop: -1)
            }
            self.timeLabel.textColor = self.appDelegate.wereWolfColor
        }
        self.timeLabel.text = self.time2Text(time: self.time)
    }
    
    private func time2Text(time : Int) -> String{
        let min = time / 60
        let sec = time % 60
        
        var minTxt = ""
        if min < 10 {
            minTxt = "0\(min)"
        }else {
            minTxt = "\(min)"
        }
        
        var secTxt = ""
        if sec < 10 {
            secTxt = "0\(sec)"
        }else {
            secTxt = "\(sec)"
        }
        return minTxt + ":" + secTxt
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
