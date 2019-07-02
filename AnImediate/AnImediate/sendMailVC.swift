//
//  sendMailVC.swift
//  AnImediate
//
//  Created by 川上達也 on 2019/06/28.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import UIKit
import MessageUI

class sendMailVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func sendMail(){
        // もしメールが送信可能だったら
        if MFMailComposeViewController.canSendMail(){
            
            let mail = MFMailComposeViewController()
            
            mail.mailComposeDelegate = self as! MFMailComposeViewControllerDelegate
            // 送り先
            mail.setToRecipients(["animediate@gmail.com"])
            //件名
            mail.setSubject("件名")
            //本文
            mail.setMessageBody("ここに本文を入力してください", isHTML: false)
        
            
            
        }else{
            let alert = UIAlertController(title: "メールアドレスがありません", message: "メールアドレスを設定してください", preferredStyle: .alert)
            let dissmiss = UIAlertAction(title: "OK!", style: .cancel, handler: nil)
            alert.addAction(dissmiss)
            self.present(alert, animated: true, completion: nil)
        }
        
    
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("キャンセル")
        case .saved:
            print("下書きを保存")
        case .sent:
            print("送信成功")
            
        default:
            print("送信失敗")
        }
        dismiss(animated: true, completion: nil)
    }
    
}


