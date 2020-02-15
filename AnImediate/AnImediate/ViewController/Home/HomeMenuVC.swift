//
//  HomeMenuVC.swift
//  AnImediate
//
//  Created by 川村周也 on 2020/02/13.
//  Copyright © 2020 AI_Love_DeepLearning. All rights reserved.
//

import UIKit
import Firebase

class HomeMenuVC: UIViewController {

    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var menuTable: UITableView!
    
    let settingItem: [String] = ["アカウント", "使い方", "お問い合わせ", "プライバシー", "ライセンス", "ログアウト", "退会"]
    var nextType: textType = .license
    
    override func viewDidLoad() {
        super.viewDidLoad()

        menuTable.delegate = self
        menuTable.dataSource = self
        
        menuTable.tableFooterView = UIView(frame: .zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // メニューの位置を取得する
        let menuPos = self.menuView.layer.position
        // 初期位置を画面の外側にするため、メニューの幅の分だけマイナスする
        self.menuView.layer.position.x = -self.menuView.frame.width
        // 表示時のアニメーションを作成する
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                self.menuView.layer.position.x = menuPos.x
        },
            completion: { bool in
        })
        
    }
    
    // メニューエリア以外タップ時の処理
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch in touches {
            if touch.view?.tag == 1 {
                UIView.animate(
                    withDuration: 0.2,
                    delay: 0,
                    options: .curveEaseIn,
                    animations: {
                        self.menuView.layer.position.x = -self.menuView.frame.width
                },
                    completion: { bool in
                        self.dismiss(animated: true, completion: nil)
                }
                )
            }
        }
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

extension HomeMenuVC: UITableViewDelegate, UITableViewDataSource{
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
        let cell = menuTable.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath)
        cell.textLabel?.text = settingItem[indexPath.row]
        cell.textLabel?.textColor = .TextBlack
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
