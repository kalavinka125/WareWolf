//
//  VoteResultViewController.swift
//  WareWolf
//
//  Created by falcon@mac on H29/11/26.
//  Copyright © 平成29年 NagaoLab. All rights reserved.
//

import UIKit

class VoteResultViewController: UIViewController {
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    var voteTarget = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 投票で選ばれた人物を処刑
        self.appDelegate.playerList[self.voteTarget].isLife = false
        self.nameLabel.text = self.appDelegate.playerList[self.voteTarget].name
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
