//
//  SearchViewReducer.swift
//  AppModel
//
//  Created by 川村周也 on 2019/09/29.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import Foundation
import ReSwift

struct SearchViewReducer {
    
    static func handleAction(action: Action, state: SearchViewState?) -> SearchViewState {
        var nextState = state ?? SearchViewState()
        
        if action is AppAction.InitializeApplication {
            return SearchViewState()
        }
        
        return nextState
    }
}
