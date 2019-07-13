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
    
    var findPeers: [MCPeerID] = []
    
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
        
        let result = realm.objects(UserInfo.self)
        myInfo.id = result[0].id
        myInfo.name = result[0].name
        myInfo.comment = result[0].comment
        myInfo.icon = result[0].icon
        myInfo.background = result[0].background
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        P2PConnectivity.manager.exDelegate = self
        
        peerIcon.image = UIImage(data: peerInfo.iconData! as Data)!
        peerName.text =  peerInfo.name
    }
    
    @IBAction func acceptBtnTapped(_ sender: Any) {
        let results = realm.objects(WatchData.self).filter("userId == %@", myInfo.id)
        myData = Array(results)
        do {
            // WatchData → NSData
            let codedInfo = try NSKeyedArchiver.archivedData(withRootObject: myData, requiringSecureCoding: false)
            // データの送信
            P2PConnectivity.manager.send(data: codedInfo)
            isAccepted = true
        } catch {
            fatalError("archivedData failed with error: \(error)")
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
            let nextVC = segue.destination as! ExchangeResultVC
            nextVC.showData = peerData
        }
    }

}

extension ExchangeDataVC: ExchangeDelegate {
    func didRecieveData(data: Data) {
        if isAccepted, isReceived { // 承認してるかつデータを受け取ったら（相手も承認）
            // result画面にデータを渡す
            performSegue(withIdentifier: "toResult", sender: nil)
        } else {
            isReceived = true
            do {
                // NSData → WatchData
                let decoded = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! [WatchData]
                peerData = decoded
                // クエリによるデータの取得
                let results = realm.objects(WatchData.self).filter("userId == %@", decoded[0].userId)
                
                if results.isEmpty {
                    let data: [WatchData] = decoded
                    data[0].id = NSUUID().uuidString
                    
                    try! realm.write {
                        realm.add(peerData)
                    }
                } else {
                    // データの更新
                    try! realm.write {
                        realm.delete(results)
                        realm.add(peerData)
                    }
                }
                
                
            } catch {
                fatalError("archivedData failed with error: \(error)")
            }
        }
    }
}
