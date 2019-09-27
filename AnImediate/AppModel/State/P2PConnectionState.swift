//
//  P2PConnectionState.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/09/23.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import ReSwift
import MultipeerConnectivity

public struct P2PConnectionState: StateType {
    public internal(set) var connectionState: MCSessionState = .notConnected
    public internal(set) var isAdvertising = false
    public internal(set) var isBrowsing = false
    public internal(set) var isLoading = false
    public internal(set) var error: AnimediateError?
}

extension P2PConnectionState: Equatable {
    public static func == (lhs: P2PConnectionState, rhs: P2PConnectionState) -> Bool {
        return lhs.connectionState == rhs.connectionState
        && lhs.isAdvertising == rhs.isBrowsing
        && lhs.isLoading == rhs.isLoading
    }
}
