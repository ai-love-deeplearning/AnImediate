//
//  ExchangeAcceptViewAction.swift
//  AppModel
//
//  Created by 川村周也 on 2019/09/28.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import Foundation
import ReSwift

public struct ExchangeAcceptViewAction {
    
    public struct Initialize: Action {
        public init() {}
    }
    
    public struct DismissErrorAlert: Action {
        public init() {}
    }
    
    public struct SetPeerID: Action {
        public let peerID: String
        public init(peerID: String) {
            self.peerID = peerID
        }
    }
    
}
