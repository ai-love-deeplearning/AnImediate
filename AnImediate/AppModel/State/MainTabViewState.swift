//
//  MainTabViewState.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/09/22.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import ReSwift

public struct MainTabViewState: StateType, Equatable {
    public internal(set) var transitionType = TransitionType.none
    public internal(set) var accountNumber: String?
    public internal(set) var accountBalance: String?
    public internal(set) var fundCd: String?
}
