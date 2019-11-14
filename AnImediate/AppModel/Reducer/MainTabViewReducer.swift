//
//  MainTabViewReducer.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/09/22.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import Foundation
import ReSwift

public struct MainTabViewReducer {
    
    public static func handleAction(action: Action, state: MainTabViewState?) -> MainTabViewState {
        var nextState = state ?? MainTabViewState()
        
        switch action {
            
        case let action as MainTabViewAction.SetTransitionType:
            nextState.transitionType = action.transitionType
            nextState.accountNumber = action.accountNumber
            nextState.accountBalance = action.accountBalance
            nextState.fundCd = action.fundCd
            
        default:
            break
        }
        
        return nextState
    }
}
