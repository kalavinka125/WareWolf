//
//  UIViewControllerExtension.swift
//  WareWolf
//
//  Created by falcon@mac on H29/11/21.
//  Copyright © 平成29年 NagaoLab. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(viewController: UIViewController, message: String, buttonTitle:String){
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action : UIAlertAction = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
        action.setValue(UIColor.black, forKey: "titleTextColor")
        alert.addAction(action)
        
        let font = UIFont(name: "PixelMplus10-Regular", size: 18)
        let messageFont : [String : AnyObject] = [NSFontAttributeName : font!]
        let attributedMessage = NSMutableAttributedString(string: message, attributes: messageFont)
        alert.setValue(attributedMessage, forKey: "attributedMessage")
        
        DispatchQueue.main.async(execute: {
            viewController.present(alert, animated: true, completion:nil)
        })
    }
    
    /// フォアグラウンドのアラートを取得
    ///
    /// - Returns: フォアグラウンドのアラート
    func getForegroundAlertController() -> UIAlertController? {
        var viewController = UIApplication.shared.keyWindow?.rootViewController
        while let controller = viewController?.presentedViewController {
            if controller is UIAlertController {
                viewController = controller
                break
            }
        }
        guard let alert = viewController as? UIAlertController else {
            return nil
        }
        return alert
    }
}
