//
//  SettingTextVC.swift
//  AnImediate
//
//  Created by 川上達也 on 2019/07/07.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import UIKit

enum textType {
    case license
    case privacy
}

class SettingTextVC: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    var contentText: String = ""
    var type: textType = .license
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch type {
        case .license:
            contentText = "license"
        case .privacy:
            contentText = "privacy"
        }
        textView.text = contentText
            //textView.text = "1234567890abcdefghijklmnopqrstuwxyz 1234567890 abcdefghijklmnopqrstuwxyz \na\nb\nc\ndefghijklmnopqrstuwxyz \n http://www.gclue.com\n"
    }
    
}
