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
    case Use
}

class SettingTextVC: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    var type: textType = .privacy
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch (type) {
        case .Use:
            if let FilePath = Bundle.main.path(forResource: "HowToUse", ofType: "txt"){
                let HowToUse = try? String(contentsOfFile: FilePath, encoding: String.Encoding.utf8 )
            textView.text = HowToUse
            }            
        case .privacy:
            if let FilePath = Bundle.main.path(forResource: "privacy", ofType: "txt"){
                let privacy = try? String(contentsOfFile: FilePath, encoding: String.Encoding.utf8 )
                textView.text = privacy
            }
        case .license:
            if let FilePath = Bundle.main.path(forResource: "license", ofType: "txt"){
                let licence = try? String(contentsOfFile: FilePath, encoding: String.Encoding.utf8 )
                textView.text = licence
            }
           
        }
     
    }
    



}
