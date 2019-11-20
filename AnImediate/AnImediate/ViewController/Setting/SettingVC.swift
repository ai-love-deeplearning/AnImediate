//
//  SettingVC.swift
//  AnImediate
//
//  Created by 川上達也 on 2019/06/26.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import UIKit
import Firebase

class SettingVC: UIViewController {

    @IBOutlet weak var settingTableView: UITableView!
    
    let settingItem: [String] = ["アカウント", "使い方", "お問い合わせ", "プライバシー", "ライセンス", "ログアウト", "退会"]
    var nextType: textType = .license
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingTableView.delegate = self
        settingTableView.dataSource = self
    }
    
    private func showErrorIfNeeded(_ errorOrNil: Error?) {
        guard errorOrNil != nil else { return }
        
        let message = "エラーが起きました"
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "toText"{
            let nextView = segue.destination as! SettingTextVC
            nextView.type = nextType
        }
    }
    
}

extension SettingVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingItem.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.leastNormalMagnitude
        }
        return tableView.sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = settingTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) 
        cell.textLabel?.text = settingItem[indexPath.row]
        // 色仮置き
        cell.textLabel?.textColor = .MainThema
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch indexPath.row {
        case 0:
            self.performSegue(withIdentifier: "toAccount", sender: self)
            
        case 1:
            self.performSegue(withIdentifier: "toText", sender: self)
        case 2:
            self.performSegue(withIdentifier: "toMail", sender: self)
        case 3:
            nextType = .privacy
            self.performSegue(withIdentifier: "toText", sender: self)
        case 4:
            nextType = .license
            self.performSegue(withIdentifier: "toText", sender: self)
        case 5:
            let alert = UIAlertController(title: "ログアウト", message: "ログアウトしますか？", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                (action) in
                do {
                    try Auth.auth().signOut()
                    self.performSegue(withIdentifier: "toLogin", sender: self)
                } catch let error {
                    self.showErrorIfNeeded(error)
                }
            }))
            alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
            self.present(alert, animated: true, completion: nil)
        case 6:
            Auth.auth().currentUser?.delete() { [weak self] error in
                guard let self = self else { return }
                if error != nil {
                    self.performSegue(withIdentifier: "toLogin", sender: self)
                }
                self.showErrorIfNeeded(error)
            }
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
