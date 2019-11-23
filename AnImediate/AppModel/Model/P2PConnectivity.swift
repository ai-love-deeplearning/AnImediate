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
    func sendArchiveModel(data: Data?) -> Single<Bool>
    func sendNotification() -> Single<Bool>
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
        let peerID = MCPeerID(displayName: displayName.isEmpty ? "peer" : displayName)
        
        self.session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .optional)
        self.advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: serviceType)
        self.browser = MCNearbyServiceBrowser(peer: peerID, serviceType: serviceType)
        
        self.session.delegate = self
        self.advertiser.delegate = self
        self.browser.delegate = self
        
        self.advertiser.startAdvertisingPeer()
        self.browser.startBrowsingForPeers()
        
        print("@@@ Session @@@: \(session)")
        
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
                guard let data = data else {
                    observer(.error(P2PError.accountDataEmpty))
                    return Disposables.create()
                }
                if self.session == nil {
                    observer(.error(P2PError.sessionNil))
                    return Disposables.create()
                }
                print("@@@ SendAccount to @@@: \(self.session.connectedPeers)")
                try self.session.send(data, toPeers: self.session.connectedPeers, with: .reliable)
            } catch {
                observer(.error(P2PError.accountSendFailed))
            }
            observer(.success(true))
            return Disposables.create()
        }
    }
    
    // 受信成功通知
    public func sendNotification() -> Single<Bool> {
        return Single.create { observer -> Disposable in
            do {
                print("@@@ Notice @@@")
                guard let data = "success".data(using:.utf8) else {
                    observer(.error(P2PError.notificationError))
                    return Disposables.create()
                }
                try self.session.send(data, toPeers: self.session.connectedPeers, with: .reliable)
            } catch {
                observer(.error(P2PError.notificationError))
            }
            observer(.success(true))
            return Disposables.create()
        }
    }
    
    @discardableResult
    public func sendArchiveModel(data: Data?) -> Single<Bool> {
        return Single.create { observer -> Disposable in
            do {
                guard let data = data else {
                    observer(.error(P2PError.archiveDataEmpty))
                    return Disposables.create()
                }
                if self.session == nil {
                    observer(.error(P2PError.sessionNil))
                    return Disposables.create()
                }
                print("@@@ SendArchive to @@@: \(self.session.connectedPeers)")
                try self.session.send(data, toPeers: self.session.connectedPeers, with: .reliable)
            } catch {
                observer(.error(P2PError.archiveSendFailed))
                return Disposables.create()
            }
            observer(.success(true))
            return Disposables.create()
        }
    }
    
}

// MARK: - MCSessionDelegate
extension P2PConnectivity: MCSessionDelegate {
    
    public func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
        certificateHandler(true)
    }
    
    public func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        // TODO:- 画面遷移の処理をVC側で記述
        if let decoded = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? AccountModel {
            if decoded.userID == AccountModel.read().userID { return }
            print("@@@ RecievePeer @@@: \(decoded.userID)")
            
            PeerModel.set(data: decoded)
            receiveDataSubject.onNext((type: "PeerModel", id: decoded.userID))
            
        } else if let decoded = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [ArchiveModel] {
            // TODO:- 送られてきた履歴が空でない保証
            if decoded.isEmpty { return }
            else if decoded.first!.userID == AccountModel.read().userID { return }
            print("@@@ RecieveArchive @@@: \(decoded.first!)")
            
            ArchiveModel.set(archives: decoded)
            receiveDataSubject.onNext((type: "ArchiveModel", id: decoded.first!.userID))
            
        } else if let decoded = String(data: data, encoding: .utf8) {
            print("@@@ RecieveNotice @@@: \(decoded)")
            if decoded == "success" {
                receiveDataSubject.onNext((type: "Notification", id: decoded))
            }
            
        } else {
            // TODO:- 予期せぬデータが送られてきたときのエラーハンドリング
//            receiveDataSubject.onNext((type: "Notification", id: decoded))
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
        print("State: \(state.rawValue)")
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
