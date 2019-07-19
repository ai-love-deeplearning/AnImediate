//
//  ExchangeVC.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/06/27.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import MultipeerConnectivity

class ExchangeVC: UIViewController {
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var seachLLabel: UILabel!
    
    var timer: Timer!
    var searchingTimer: Timer!
    var searchingTime: Int = 0
    var count = 0
    
    var isRecieveWatch: Bool = false
    
    var dateString = ""
    let now = NSDate()
    let formatter = DateFormatter()
    
    var myInfo: UserInfo = UserInfo()
    var peerInfo: UserInfo = UserInfo()
    
    // 告知用の文字列（相手を検索するのに使用するIDの様なもの）
    // 一つのハイフンしか使用できず、15文字以下である必要がある
    let serviceType = "fun-AnImediate"
    
    @objc func labelAnimetion(_ tm: Timer) {
        switch count {
        case 0:
            seachLLabel.text = "Searching.  "
            count = 1
        case 1:
            seachLLabel.text = "Searching.. "
            count = 2
        case 2:
            seachLLabel.text = "Searching..."
            count = 0
        default:
            break;
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        P2PConnectivity.manager.exDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initGradientLayer()
        
        self.formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        self.dateString = self.formatter.string(from: now as Date)
        
        self.peerInfo.excangedAt = self.dateString
        
        let realm = try! Realm()
        
        let result = realm.objects(UserInfo.self)
        myInfo = result[0].copy() as! UserInfo
        
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.isRemovedOnCompletion = true
        rotateAnimation.fromValue = 0
        rotateAnimation.toValue = CGFloat.pi * 2.0
        rotateAnimation.duration = 2.0 // 周期3秒
        rotateAnimation.repeatCount = .infinity
        
        loadingView.layer.add(rotateAnimation, forKey: "rotateindicator")
        
        timer = Timer.scheduledTimer(timeInterval: 2.1, target: self, selector: #selector(self.labelAnimetion(_:)), userInfo: nil, repeats: true)
        timer.fire()
        
        self.searchingTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.notFound), userInfo: nil, repeats: false)
        
        P2PConnectivity.manager.start(
            serviceType: serviceType,
            displayName: "player",
            stateChangeHandler: { state in
                
                switch state {
                case .notConnected:
                    self.searchingTimer.fire()
                    break
                case .connecting:
                    self.searchingTimer.invalidate()
                    self.searchingTime = 0
                    break
                case .connected:
                    DispatchQueue.main.async {
                        do {
                            //  UserInfo → NSData
                            let codedInfo = try NSKeyedArchiver.archivedData(withRootObject: self.myInfo, requiringSecureCoding: false)
                            P2PConnectivity.manager.send(data: codedInfo)
                        } catch {
                            fatalError("archivedData failed with error: \(error)")
                        }
                    }
                @unknown default:
                    break
                }
                
        }, profileRecieveHandler: { data in
            
        }
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
        timer = nil
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        initGradientLayer()
    }
    
    func initGradientLayer() {
        let gradientRingLayer = WCGraintCircleLayer(bounds: loadingView.bounds, position: CGPoint(x: loadingView.frame.width/2, y: loadingView.frame.height/2), fromColor: .deepMagenta(), toColor: UIColor.white, linewidth: 8.0, toValue: 0)
        if loadingView.layer.sublayers != nil {
            loadingView.layer.sublayers!.forEach {
                $0.removeFromSuperlayer()
            }
        }
        loadingView.layer.addSublayer(gradientRingLayer)
        let duration = 0.8
        gradientRingLayer.animateCircleTo(duration: duration, fromValue: 0, toValue: 0.99)
    }
    
    @objc func notFound() {
        searchingTime += 1
        if searchingTime == 60 {
            searchingTimer.invalidate()
            performSegue(withIdentifier: "toNotFound", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPopUpModal" {
            let nextVC = segue.destination as! ExchangeDataVC
            nextVC.peerInfo = peerInfo
            nextVC.isRecievedWatch = self.isRecieveWatch
        }
    }
}

extension ExchangeVC: ExchangeDelegate {
    func didRecieveData(data: Data) {
        print("userhInfoReceive")
        
        DispatchQueue.global(qos: .background).async {
            do {
                let realm = try! Realm()
                // NSData → UserInfo
                print(data)
                if let decoded = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UserInfo {
                    self.peerInfo = decoded.copy() as! UserInfo
                    let peer = realm.objects(UserInfo.self).filter("id == %@", decoded.id)
                    if peer.isEmpty {
                        try! realm.write {
                            realm.add(decoded)
                        }
                    } else {
                        try! realm.write {
                            peer[0].name = decoded.name
                            peer[0].comment = decoded.comment
                            peer[0].icon = decoded.icon
                            peer[0].background = decoded.background
                            peer[0].excangedAt = decoded.excangedAt
                        }
                    }
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "toPopUpModal", sender: nil)
                    }
                } else if let decoded = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [WatchData] {
                    self.isRecieveWatch = true
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
                }
            } catch {
                fatalError("archivedData failed with error: \(error)")
            }
        }
    }
}
