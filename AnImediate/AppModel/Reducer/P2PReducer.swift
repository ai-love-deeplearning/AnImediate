//
//  P2PReducer.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/09/23.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import Foundation
import ReSwift
import MultipeerConnectivity

struct P2PReducer {
    
    static func handleAction(action: Action, state: P2PConnectionState?) -> P2PConnectionState {
        var nextState = state ?? P2PConnectionState()
        
        if action is AppAction.InitializeApplication {
            return P2PConnectionState()
        }
        
        switch action {
            
        case is P2PAction.Initialize:
            nextState = P2PConnectionState()
            nextState.connectionState = .notConnected
            
        case is P2PAction.DismissErrorAlert:
            nextState.error = nil
            
        case let action as P2PAction.ChangeState:
            nextState.connectionState = action.connectionState
            if action.connectionState == .notConnected {
                nextState.isAdvertising = false
                nextState.isBrowsing = false
            } else {
                nextState.isAdvertising = true
                nextState.isBrowsing = true
            }
            
            nextState.error = nil
            
        case is P2PAction.SendAccountModelSuccess:
            nextState.isLoading = false
            nextState.error = nil
            
        case is P2PAction.SendArchiveModelSuccess:
            nextState.isLoading = false
            nextState.error = nil

        default:
            break
            
        }
        
        return nextState
    }

}
