//
//  P2PAction.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/09/23.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import Foundation
import ReSwift
import MultipeerConnectivity

public struct P2PAction {
    
    public struct Initialize: Action {
        public init() {}
    }
    
    public struct DismissErrorAlert: Action {
        public init() {}
    }
    
    public struct StartSearching: Action {
        public init() {}
    }
    
    public struct StartConnecting: Action {
        public let connectionState: MCSessionState
        public init(connectionState: MCSessionState) {
            self.connectionState = connectionState
        }
    }
    
    public struct ChangeState: Action {
        public let connectionState: MCSessionState
        public init(connectionState: MCSessionState) {
            self.connectionState = connectionState
        }
    }
    
    public struct SendAccountModelSuccess: Action {
        public init() {}
    }
    
    public struct SendArchiveModelSuccess: Action {
        public init() {}
    }

}
