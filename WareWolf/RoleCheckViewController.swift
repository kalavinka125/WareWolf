//
//  RoleCheckViewController.swift
//  WareWolf
//
//  Created by falcon@mac on H29/11/20.
//  Copyright © 平成29年 NagaoLab. All rights reserved.
//

import UIKit

enum RoleCheckVC {
    case none
    case check
    case vote
}

class RoleCheckViewController: UIViewController {
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    private let RESULT_SEGUE = "GO_TO_ROLE_RESULT"
    private let VOTE_SEGUE = "GO_TO_VOTE"
    var flag : RoleCheckVC = .check
    var voteFlag : VoteFlag = .normal
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.nameLabel.adjustsFontSizeToFitWidth = true
        self.nameLabel.text = self.appDelegate.playerList[self.appDelegate.playerID].name
        if flag == .check {
            self.button.setTitle("確認", for: .normal)
            self.imageView.image = UIImage(named: "-1")
        }else if flag == .vote{
            self.button.setTitle("投票", for: .normal)
            self.imageView.image = UIImage(named: "finger2")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.VOTE_SEGUE {
            let next = segue.destination as! VoteViewController
            next.voteFlag = self.voteFlag
        }
    }
    
    @IBAction func tappedCheckButton(_ sender: Any) {
        let name = self.appDelegate.playerList[self.appDelegate.playerID].name
        let message = name + " さん で\n間違いありませんか？"
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let font = UIFont(name: "PixelMplus10-Regular", size: 18)
        let messageFont : [String : AnyObject] = [NSFontAttributeName : font!]
        let attributedMessage = NSMutableAttributedString(string: message, attributes: messageFont)
        alert.setValue(attributedMessage, forKey: "attributedMessage")
        let action : UIAlertAction = UIAlertAction(title: "はい", style: .default, handler: { okAction in
            DispatchQueue.main.async {
                if self.flag == .check {
                    self.performSegue(withIdentifier: self.RESULT_SEGUE, sender: self)
                }else if self.flag == .vote {
                    self.performSegue(withIdentifier: self.VOTE_SEGUE, sender: self)
                }
            }
        })
        action.setValue(UIColor.black, forKey: "titleTextColor")
        let cancel = UIAlertAction(title: "いいえ", style: .cancel, handler: nil)
        cancel.setValue(UIColor.black, forKey: "titleTextColor")
        alert.addAction(cancel)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
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
