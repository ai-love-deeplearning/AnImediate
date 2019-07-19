//
//  SettingAccountVC.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/07/19.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import UIKit
import RealmSwift

class SettingAccountVC: UIViewController {
    
    let realm = try! Realm()
    var userInfos: Results<UserInfo>!
    var watchDatas: Results<WatchData>!
    var myInfo: UserInfo = UserInfo()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userInfos = realm.objects(UserInfo.self)
        myInfo = userInfos[0].copy() as! UserInfo
        watchDatas = realm.objects(WatchData.self)
    }
    
    @IBAction func exResetBtnTapped(_ sender: Any) {
        let alert = UIAlertController(title: "交換情報", message: "本当に削除してもよろしいですか？", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            (action) in
            try! self.realm.write {
                
                self.realm.delete(self.userInfos)
                self.realm.add(self.myInfo)
            }
        }))
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func wdResetBtnTapped(_ sender: Any) {
        let alert = UIAlertController(title: "視聴情報", message: "本当に削除してもよろしいですか？", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            (action) in
            try! self.realm.write {
                self.realm.delete(self.watchDatas)
            }
        }))
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
        self.present(alert, animated: true, completion: nil)
        
    }

}
