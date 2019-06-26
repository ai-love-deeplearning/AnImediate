//
//  SettingVC.swift
//  AnImediate
//
//  Created by 川上達也 on 2019/06/26.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import UIKit

class SettingVC: UIViewController {

    @IBOutlet weak var settingTableView: UITableView!
    
    let settingItem: [String] = ["アカウント","使い方","お問い合わせ","プライバシー","ライセンス"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingTableView.delegate = self
        settingTableView.dataSource = self
    }
}

extension SettingVC: UITableViewDelegate {
    
}

extension SettingVC:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = settingTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) 
        cell.textLabel?.text = settingItem[indexPath.row]
        // 色仮置き
        cell.textLabel?.textColor = UIColor.red
        return cell
    }
}