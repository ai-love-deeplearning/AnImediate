//
//  ExchangeAcceptVC.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/07/09.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import AppConfig
import AppModel
import UIKit
import RealmSwift
import MultipeerConnectivity
import ReSwift
import RxCocoa
import RxSwift

class ExchangeAcceptVC: UIViewController {
    
    @IBOutlet weak var peerIcon: UIImageView!
    @IBOutlet weak var peerName: UILabel!
    
    @IBOutlet weak var exchangeBtn: UIButton!
    @IBOutlet weak var canselBtn: UIButton!
    
    //var myInfo: AccountModel = AccountModel()
    var myData: [ArchiveModel] = []
    //var peerInfo: PeerModel = PeerModel()
    var peerData: [ArchiveModel] = []
    
    var recentlyDate = ""
    var passTime = 0
    var isAccepted = false
    var isReceived = false
    var isRecievedWatch = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //P2PConnectivity.exDelegate = self
        setMyInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.peerIcon.image = UIImage(data: self.peerInfo.iconData! as Data)!
        //self.peerName.text =  self.peerInfo.name
        self.navigationItem.hidesBackButton = true
        setMyInfo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isAccepted {
            
        } else {
            let realm = try! Realm()
            //let result = realm.objects(PeerModel).filter("id == %@", peerInfo.id)
            try! realm.write {
                //realm.delete(result[0])
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        exchangeBtn.layer.cornerRadius = exchangeBtn.frame.height / 2
        canselBtn.layer.cornerRadius = canselBtn.frame.height / 2
    }
    
    private func setMyInfo() {
        let realm = try! Realm()
        /*
        let result = realm.objects(UserInfo.self)
        let myDataResults = realm.objects(WatchData.self).filter("userId == %@", myInfo.id)
        myInfo.id = result[0].id
        myInfo.name = result[0].name
        myInfo.comment = result[0].comment
        myInfo.icon = result[0].icon
        myInfo.background = result[0].background
        myDataResults.forEach {
            myData.append($0.copy() as! WatchData)
        }*/
    }
    
    @IBAction func acceptBtnTapped(_ sender: Any) {
        print("accept")
        self.isAccepted = true
        do {
            // WatchData → NSData
            let codedInfo = try NSKeyedArchiver.archivedData(withRootObject: self.myData, requiringSecureCoding: false)
            print(codedInfo)
            // データの送信
            //P2PConnectivity.manager.send(data: codedInfo)
            
            if self.isReceived || self.isRecievedWatch {
                self.navigationController?.popToRootViewController(animated: true)
            }
            
        } catch {
            fatalError("archivedData failed with error: \(error)")
        }
    }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        let realm = try! Realm()
        /*
        let result = realm.objects(UserInfo.self).filter("id == %@", peerInfo.id)
        try! realm.write {
            realm.delete(result[0])
        }
        self.navigationController?.popViewController(animated: true)*/
    }
    
    
    func stringFromDate(date: Date, format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toResult" {
            //P2PConnectivity.manager.stop()
            DispatchQueue.main.async {
                do {
                    // WatchData → NSData
                    let codedData = try NSKeyedArchiver.archivedData(withRootObject: self.peerData, requiringSecureCoding: false)
                    UserDefaults.standard.set(codedData, forKey: "data")
                } catch {
                    fatalError("archivedData failed with error: \(error)")
                }
            }
        }
    }

}

private extension RxStore where AnyStateType == ExchangeViewState {
    var state: Driver<ExchangeViewState> {
        return stateDriver.distinctUntilChanged()
    }
    
    var isReceivePeerModel: Driver<Bool> {
        return state.mapDistinct { $0.isReceivePeerModel }
    }
    
    var isReceiveArchiveModel: Driver<Bool> {
        return state.mapDistinct { $0.isReceiveArchiveModel }
    }
    
    var isSendAccountModel: Driver<Bool> {
        return state.mapDistinct { $0.isSendAccountModel }
    }
    
    var isSendArchiveModel: Driver<Bool> {
        return state.mapDistinct { $0.isSendArchiveModel }
    }
    
    var error: Driver<AnimediateError> {
        return state.mapDistinct { $0.error }.skipNil()
    }
    
}

/*
extension ExchangeDataVC: ExchangeDelegate {
    func didRecieveData(data: Data) {
 
        print("watchDataReceive")
        self.isReceived = true
        DispatchQueue.main.async {
            let realm = try! Realm()
            
            do {
                // NSData → WatchData
                if let decoded = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [WatchData] {
                    self.peerData = decoded
                    // クエリによるデータの取得
                    let results = realm.objects(WatchData.self).filter("userId == %@", decoded[0].userId)
                    
                    if results.isEmpty {
                        decoded.forEach {
                            $0.id = NSUUID().uuidString
                        }
                        
                        try! realm.write {
                            realm.add(decoded)
                        }
                    } else {
                        decoded.forEach {
                            $0.id = NSUUID().uuidString
                        }
                        // データの更新
                        try! realm.write {
                            realm.delete(results)
                            realm.add(decoded)
                        }
                    }
                } else {
                    return
                }
                
                if self.isAccepted { // 承認してるかつデータを受け取って登録していたら（相手も承認）
                    self.navigationController?.popToRootViewController(animated: true)
                }
                
            } catch {
                fatalError("archivedData failed with error: \(error)")
            }
        }
    }
}*/

