//
//  ExchangeDataVC.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/07/09.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import UIKit
import RealmSwift
import MultipeerConnectivity

class ExchangeDataVC: UIViewController {
    
    @IBOutlet weak var peerIcon: UIImageView!
    @IBOutlet weak var peerName: UILabel!
    
    
    let realm = try! Realm()
    
    var myInfo: UserInfo = UserInfo()
    var myData: [WatchData] = []
    var peerInfo: UserInfo = UserInfo()
    var peerData: [WatchData] = []
    
    var recentlyDate = ""
    var passTime = 0
    var isAccepted = false
    var isReceived = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        P2PConnectivity.manager.exDelegate = self
        setMyInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.peerIcon.image = UIImage(data: self.peerInfo.iconData! as Data)!
            self.peerName.text =  self.peerInfo.name
        }
        
        setMyInfo()
        
        myData = Array(realm.objects(WatchData.self).filter("userId == %@", myInfo.id))
    }
    
    private func setMyInfo() {
        let result = realm.objects(UserInfo.self)
        myInfo.id = result[0].id
        myInfo.name = result[0].name
        myInfo.comment = result[0].comment
        myInfo.icon = result[0].icon
        myInfo.background = result[0].background
    }
    
    @IBAction func acceptBtnTapped(_ sender: Any) {
        print("accept")
            DispatchQueue.main.async() {
            do {
                // WatchData → NSData
                let codedInfo = try NSKeyedArchiver.archivedData(withRootObject: self.myData, requiringSecureCoding: false)
                print(codedInfo)
                // データの送信
                P2PConnectivity.manager.send(data: codedInfo)
                if self.isReceived {
                    self.performSegue(withIdentifier: "toResult", sender: nil)
                }
                self.isAccepted = true
            } catch {
                fatalError("archivedData failed with error: \(error)")
            }
        }
    }
    
    func stringFromDate(date: Date, format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    // ToDo: 現在時刻はDateFormaterでフォーマットする
    func getDateAndTime() {
        // 現在日時
        let date = Date()
        // 年月日時分秒をそれぞれ個別に取得
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        
        self.recentlyDate = "\(month)" + "/" + "\(day)" + " " + "\(hour)" + ":" + "\(minute)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toResult" {
            P2PConnectivity.manager.stop()
            do {
                // WatchData → NSData
                let codedData = try NSKeyedArchiver.archivedData(withRootObject: peerData, requiringSecureCoding: false)
                UserDefaults.standard.set(codedData, forKey: "data")
            } catch {
                fatalError("archivedData failed with error: \(error)")
            }
        }
    }

}

extension ExchangeDataVC: ExchangeDelegate {
    func didRecieveData(data: Data) {
        print("watchDataReceive")
        self.isReceived = true
        DispatchQueue.main.async {
            if self.isAccepted, self.isReceived { // 承認してるかつデータを受け取ったら（相手も承認）
                // result画面にデータを渡す
                self.performSegue(withIdentifier: "toResult", sender: nil)
                
            } else {
                if type(of: data) == UserInfo.self {
                    
                }
                do {
                    // NSData → WatchData
                    let decoded = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! [WatchData]
                    self.peerData = decoded
                    // クエリによるデータの取得
                    let results = self.realm.objects(WatchData.self).filter("userId == %@", decoded[0].userId)
                    
                    if results.isEmpty {
                        self.peerData.forEach {
                            $0.id = NSUUID().uuidString
                        }
                        
                        try! self.realm.write {
                            self.realm.add(self.peerData)
                        }
                    } else {
                        self.peerData.forEach {
                            $0.id = NSUUID().uuidString
                        }
                        // データの更新
                        try! self.realm.write {
                            self.realm.delete(results)
                            self.realm.add(self.peerData)
                        }
                    }
                } catch {
                    fatalError("archivedData failed with error: \(error)")
                }
            }
        }
    }
}
