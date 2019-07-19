//
//  P2PConnectivity.swift
//  surechigaiApp
//
//  Created by 川村周也 on 2019/02/15.
//  Copyright © 2019 川村周也. All rights reserved.
//

import UIKit
import MultipeerConnectivity

protocol WaitDelegate {
    func reloadPeer(peerID: MCPeerID)
}

protocol ExchangeDelegate {
    func didRecieveData(data: Data)
}

class P2PConnectivity: NSObject {
    
    static let manager = P2PConnectivity()
    
    static var withDiscoveryInfos : [String : String] = [:]
    
    var waitDelegate: WaitDelegate?
    var exDelegate: ExchangeDelegate?
    
    var state = MCSessionState.notConnected {
        didSet {
            stateChangeHandler?(state)
        }
    }
    
    private var stateChangeHandler: ((MCSessionState) -> Void)? = nil
    private var profileRecieveHandler: ((Data) -> Void)? = nil
    private var foundPeerHandler: (() -> Void)? = nil
    
    var session: MCSession!
    private var advertiser: MCNearbyServiceAdvertiser!
    private var browser: MCNearbyServiceBrowser!
    
    private override init() {
    }
    
    func start(serviceType: String, displayName: String, stateChangeHandler: ((MCSessionState) -> Void)? = nil,
               profileRecieveHandler: ((Data) -> Void)? = nil) {
        self.stateChangeHandler = stateChangeHandler
        self.profileRecieveHandler = profileRecieveHandler
        
        let peerID = MCPeerID(displayName: displayName)
        
        session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .optional)
        session.delegate = self
        
        advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: serviceType)
        advertiser.delegate = self
        
        browser = MCNearbyServiceBrowser(peer: peerID, serviceType: serviceType)
        browser.delegate = self
        
        advertiser.startAdvertisingPeer()
        browser.startBrowsingForPeers()
    }
    
    func stop() {
        advertiser.stopAdvertisingPeer()
        browser.stopBrowsingForPeers()
        session.disconnect()
    }
    
    func invite(peer: MCPeerID) {
        browser.invitePeer(peer, to: session, withContext: nil, timeout: 0)
    }
    /*
    func showAcceptAlert(parent: UIViewController, handler: @escaping (Bool) -> Void) {
        var ret: Bool = true
        let dialog = UIAlertController(title: "招待", message: "招待を受けています。承認しますか？", preferredStyle: .actionSheet)
        let act_ok = UIAlertAction(title: "OK", style: .default) { action in
            handler(true)
        }
        let act_cancel = UIAlertAction(title: "キャンセル", style: .cancel) { action in
            handler(false)
        }
        dialog.addAction(act_ok)
        dialog.addAction(act_cancel)
        
        parent.present(dialog, animated: true, completion: nil)
    }*/
    
    @discardableResult
    func send(data: Data) -> Bool {
        guard case .connected = state else { return false }
        
        do {
            try session.send(data, toPeers: session.connectedPeers, with: .reliable)
        } catch {
            print(error.localizedDescription)
            print("エラー: 正常にデータの送信が行われませんでした")
            return false
        }
        return true
    }
    
}

// MARK: - MCSessionDelegate
extension P2PConnectivity: MCSessionDelegate {
    
    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
        certificateHandler(true)
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        //profileRecieveHandler?(data)
        self.exDelegate?.didRecieveData(data: data)
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        //print(#function)
        assertionFailure("Not support")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        //print(#function)
        assertionFailure("Not support")
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        //print(#function)
        assertionFailure("Not support")
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        //print(#function)
        
        switch state {
        case .notConnected:
            print("state: notConnected")
            // 再度検索を開始
            advertiser.startAdvertisingPeer()
            browser.startBrowsingForPeers()
        case .connected:
            print("state: connected")
        case .connecting:
            print("state: connecting")
            // 接続開始されたので一旦停止
            advertiser.stopAdvertisingPeer()
            browser.stopBrowsingForPeers()
        @unknown default:
            break
        }
        self.state = state
    }
    
}

// MARK: - MCNearbyServiceAdvertiserDelegate
extension P2PConnectivity: MCNearbyServiceAdvertiserDelegate {
    
    // 招待を受けとったときに呼ばれる
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print(#function)
        
        print("InvitationFrom: \(peerID)")
        // 招待は常に受ける
        invitationHandler(true, session)
        
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        //print(#function)
        print(error)
    }
    
}

// MARK: - MCNearbyServiceBrowserDelegate
extension P2PConnectivity: MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        //print(#function)
        print("lost: \(peerID)")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        //print(#function)
        print("found: \(peerID)")
        // 見つけたら即招待
        // ToDo: ここにUI関連の処理を入れれば好きなUIにできる？
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 0)

        self.waitDelegate?.reloadPeer(peerID: peerID)
        
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        //print(#function)
        print(error)
    }
    
}
