//
//  ExchangeSearchViewAction.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/09/22.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import Foundation
import ReSwift

public struct ExchangeSearchViewAction {
    
    public struct Initialize: Action {
        public init() {}
    }
    
    public struct DismissErrorAlert: Action {
        public init() {}
    }
    
    public struct Disconnect: Action {
        public init() {}
    }
    
    public struct SendAccountModel: Action {
        public init() {}
    }
    
    public struct ReceivePeerModel: Action {
        public init() {}
    }
    
    public struct SendArchiveModel: Action {
        public init() {}
    }
    
    public struct ReceiveArchiveModel: Action {
        public init() {}
    }
    
    public struct SendNotification: Action {
        public init() {}
    }
    
    public struct ReceiveNotification: Action {
        public init() {}
    }
    
}
