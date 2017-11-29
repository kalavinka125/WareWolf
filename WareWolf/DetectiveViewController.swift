//
//  DetectiveViewController.swift
//  WareWolf
//
//  Created by falcon@mac on H29/11/30.
//  Copyright © 平成29年 NagaoLab. All rights reserved.
//

import UIKit

class DetectiveViewController: UIViewController {
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.titleLabel.text = "\(self.appDelegate.playerList[self.appDelegate.detectiveID].name)の役職は"
        if self.appDelegate.soundPlayer.isPlaying {
            self.appDelegate.soundPlayer.stop()
        }
        self.appDelegate.soundPlay(fileName: "Mozart-Requiem-Dies-Irae", numberOfLoop: -1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tappedNextButton(_ sender: Any) {
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
