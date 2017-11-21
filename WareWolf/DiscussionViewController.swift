//
//  DiscussionViewController.swift
//  WareWolf
//
//  Created by falcon@mac on H29/11/21.
//  Copyright © 平成29年 NagaoLab. All rights reserved.
//

import UIKit

/// 議論中の画面
class DiscussionViewController: UIViewController {
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var lifeList : [Int] = []
    var time = 0
    // タイマー
    var timer : Timer!
    
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
        // 生存者の数に合わせて、議論時間を変える
        if self.lifeList.count >= 5 {
            self.time = (60 * 5)
        }else{
            self.time = (60 * self.lifeList.count)
        }
        self.timeLabel.text = self.time2Text(time: self.time)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func tappedPlusTimeButton(_ sender: Any) {
        self.time += 60
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
