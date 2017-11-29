//
//  DictatorViewController.swift
//  WareWolf
//
//  Created by falcon@mac on H29/11/29.
//  Copyright © 平成29年 NagaoLab. All rights reserved.
//

import UIKit

class DictatorViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let SEGUE_NAME = "GO_TO_DICTATOR_DETAIL"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.titleLabel.text = "\(self.appDelegate.playerList[self.appDelegate.dictatorID].name)の役職は"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tappedNextButton(_ sender: Any) {
        self.performSegue(withIdentifier: self.SEGUE_NAME, sender: self)
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
