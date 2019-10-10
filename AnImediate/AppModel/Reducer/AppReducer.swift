//
//  AppReducer.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/09/22.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import ReSwift

public struct AppReducer {
    
    public static func appReducer(action: Action, state: AppState?) -> AppState {
        
        if action is AppAction.InitializeApplication {
            return AppState()
        }
        
        return AppState(
            launchViewState: LaunchViewReducer.handleAction(action: action, state: state?.launchViewState)
        )
    }
}
