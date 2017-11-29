//
//  RoleCheckInDiscussionViewController.swift
//  WareWolf
//
//  Created by falcon@mac on H29/11/29.
//  Copyright © 平成29年 NagaoLab. All rights reserved.
//

import UIKit

class RoleCheckInDiscussionViewController: UIViewController {
    private let NEXT_SEGUE = "GO_TO_RESULT_IN_DISCUSSION"
    
    var prev : RoleCheckinDiscussion = .none
    
    @IBOutlet weak var checkRoleLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.prev == .detective{
            self.checkRoleLabel.text = "本当に、名探偵ですか？"
        }else if self.prev == .dictator {
            self.checkRoleLabel.text = "本当に、独裁者ですか？"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tappedBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func tappedCheckButton(_ sender: Any) {
        let message = self.checkRoleLabel.text!
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let font = UIFont(name: "PixelMplus10-Regular", size: 18)
        let messageFont : [String : AnyObject] = [NSFontAttributeName : font!]
        let attributedMessage = NSMutableAttributedString(string: message, attributes: messageFont)
        alert.setValue(attributedMessage, forKey: "attributedMessage")
        let action : UIAlertAction = UIAlertAction(title: "確認する", style: .default, handler: { okAction in
            DispatchQueue.main.async {
                
            }
        })
        action.setValue(UIColor.black, forKey: "titleTextColor")
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
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
