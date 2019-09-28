//
//  P2PConnectivity.swift
//  AppModel
//
//  Created by 川村周也 on 2019/09/24.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import AppConfig
import Foundation
import RxSwift
import MultipeerConnectivity

public protocol P2PConnectable {
    func startSearching(serviceType: String, displayName: String) -> (session: Observable<MCSessionState>, data: Observable<(type: String, id: String)>)
    func disconnect()
    func sendAccountModel(data: Data?) -> Single<Bool>
    func noticeSuccessAccount()
    func sendArchiveModel(data: Data?) -> Single<Bool>
    func noticeSuccessArchive()
    //func ssp5304(contentType: String) -> Single<SSP5304Res>
}

public class P2PConnectivity: NSObject, P2PConnectable {
    
    private var session: MCSession!
    private var advertiser: MCNearbyServiceAdvertiser!
    private var browser: MCNearbyServiceBrowser!
    
    private let sessiouStateSubject = PublishSubject<MCSessionState>()
    private var sessionObservable: Observable<MCSessionState> { return sessiouStateSubject.asObservable()}
    
    private let receiveDataSubject = PublishSubject<(type: String, id: String)>()
    private var receiveDataObservable: Observable<(type: String, id: String)> { return receiveDataSubject.asObservable() }
    
    public func startSearching(serviceType: String, displayName: String) -> (session: Observable<MCSessionState>, data: Observable<(type: String, id: String)>) {
        let peerID = MCPeerID(displayName: displayName)
        
        self.session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .optional)
        self.advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: serviceType)
        self.browser = MCNearbyServiceBrowser(peer: peerID, serviceType: serviceType)
        
        self.session.delegate = self
        self.advertiser.delegate = self
        self.browser.delegate = self
        
        self.advertiser.startAdvertisingPeer()
        self.browser.startBrowsingForPeers()
        
        return (session: sessionObservable, data: receiveDataObservable)
    }
    
    public func disconnect() {
        sessiouStateSubject.onCompleted()
        receiveDataSubject.onCompleted()
        session.disconnect()
        advertiser.stopAdvertisingPeer()
        browser.stopBrowsingForPeers()
    }
    
    @discardableResult
    public func sendAccountModel(data: Data?) -> Single<Bool> {
        return Single.create { observer -> Disposable in
            do {
                try self.session.send(data!, toPeers: self.session.connectedPeers, with: .reliable)
            } catch {
                observer(.error(error))
                /*
                print(error.localizedDescription)
                print("エラー: 正常にデータの送信が行われませんでした")
                */
            }
            observer(.success(true))
            return Disposables.create()
        }
    }
    
    public func noticeSuccessAccount() {
        // TODO:- 受取通知を行う
    }
    
    @discardableResult
    public func sendArchiveModel(data: Data?) -> Single<Bool> {
        return Single.create { observer -> Disposable in
            do {
                try self.session.send(data!, toPeers: self.session.connectedPeers, with: .reliable)
            } catch {
                observer(.error(error))
            }
            observer(.success(true))
            return Disposables.create()
        }
    }
    
    public func noticeSuccessArchive() {
        // TODO:- 受取通知を行う
    }
    
    
}

// MARK: - MCSessionDelegate
extension P2PConnectivity: MCSessionDelegate {
    
    public func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
        certificateHandler(true)
    }
    
    public func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        // TODO:- 画面遷移の処理をVC側で記述
        if let decoded = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? PeerModel {
            PeerModel.set(uid: decoded.userID, data: decoded)
            receiveDataSubject.onNext((type: "PeerModel", id: decoded.userID))
        } else if let decoded = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [ArchiveModel] {
            ArchiveModel.set(archives: decoded)
            // TODO:- 送られてきた履歴が空でない保証
            receiveDataSubject.onNext((type: "ArchiveModel", id: decoded.first!.userID))
        } else {
            // TODO:- 予期せぬデータが送られてきたときのエラーハンドリング
            fatalError()
        }
        
    }
    
    public func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        //print(#function)
        assertionFailure("Not support")
    }
    
    public func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        //print(#function)
        assertionFailure("Not support")
    }
    
    public func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        //print(#function)
        assertionFailure("Not support")
    }
    
    public func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        //print(#function)
        sessiouStateSubject.onNext(state)
    }
    
}

// MARK: - MCNearbyServiceAdvertiserDelegate
extension P2PConnectivity: MCNearbyServiceAdvertiserDelegate {
    
    // 招待を受けとったときに呼ばれる
    public func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print(#function)
        
        print("InvitationFrom: \(peerID)")
        // 招待は常に受ける
        invitationHandler(true, session)
        
    }
    
    public func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        //print(#function)
        print(error)
    }
    
}

// MARK: - MCNearbyServiceBrowserDelegate
extension P2PConnectivity: MCNearbyServiceBrowserDelegate {
    
    public func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        //print(#function)
        print("lost: \(peerID)")
    }
    
    public func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        //print(#function)
        print("found: \(peerID)")
        // 見つけたら即招待
        // ToDo: ここにUI関連の処理を入れれば好きなUIにできる？
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 0)
        
    }
    
    public func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        //print(#function)
        print(error)
    }
    
}
