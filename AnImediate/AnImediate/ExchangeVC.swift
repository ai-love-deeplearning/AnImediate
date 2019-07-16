//
//  ExchangeVC.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/06/27.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import UIKit
import RealmSwift
import MultipeerConnectivity

class ExchangeVC: UIViewController {
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var seachLLabel: UILabel!
    
    var timer: Timer!
    var count = 0
    
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
        
        let realm = try! Realm()
        
        let result = realm.objects(UserInfo.self)
        
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.isRemovedOnCompletion = true
        rotateAnimation.fromValue = 0
        rotateAnimation.toValue = CGFloat.pi * 2.0
        rotateAnimation.duration = 2.0 // 周期3秒
        rotateAnimation.repeatCount = .infinity
        
        loadingView.layer.add(rotateAnimation, forKey: "rotateindicator")
        
        timer = Timer.scheduledTimer(timeInterval: 2.1, target: self, selector: #selector(self.labelAnimetion(_:)), userInfo: nil, repeats: true)
        timer.fire()
        
        P2PConnectivity.manager.start(
            serviceType: serviceType,
            displayName: "player",
            stateChangeHandler: { state in
                
                switch state {
                case .notConnected:
                    // ここでタイマーを起動
                    // 30秒接続されなかったら、notfound画面を表示
                    break
                case .connecting:
                    // ここでタイマーをストップ、リセット
                    break
                case .connected:
                    DispatchQueue.main.async {
                        do {
                            // WatchData → NSData
                            let codedInfo = try NSKeyedArchiver.archivedData(withRootObject: result[0], requiringSecureCoding: false)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPopUpModal" {
            let nextVC = segue.destination as! ExchangeDataVC
            nextVC.peerInfo = peerInfo
        }
    }
}

extension ExchangeVC: ExchangeDelegate {
    func didRecieveData(data: Data) {
        print("userhInfoReceive")
        self.formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        self.dateString = self.formatter.string(from: now as Date)
        do {
            let realm = try! Realm()
            // NSData → WatchData
            print(data)
            let decoded = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! UserInfo
            peerInfo = decoded
            let peer = realm.objects(UserInfo.self).filter("id == %@", decoded.id)
            if peer.isEmpty {
                peerInfo.excangedAt = self.dateString
                try! realm.write {
                    realm.add(peerInfo)
                }
            } else {
                try! realm.write {
                    peer[0].name = peerInfo.name
                    peer[0].comment = peerInfo.comment
                    peer[0].icon = peerInfo.icon
                    peer[0].background = peerInfo.background
                    peer[0].excangedAt = self.dateString
                }
            }
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "toPopUpModal", sender: nil)
            }
        } catch {
            fatalError("archivedData failed with error: \(error)")
        }
    }
}
