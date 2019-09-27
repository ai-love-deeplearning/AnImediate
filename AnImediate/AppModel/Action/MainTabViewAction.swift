//
//  MainTabViewAction.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/09/22.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import Foundation
import ReSwift

public struct MainTabViewAction {
    
    public struct SetTransitionType: Action {
        let transitionType: TransitionType
        let accountNumber: String?
        let accountBalance: String?
        let fundCd: String?
        public init(_ type: TransitionType, accountNumber: String? = nil, accountBalance: String? = nil, fundCd: String? = nil) {
            self.transitionType = type
            self.accountNumber = accountNumber
            self.accountBalance = accountBalance
            self.fundCd = fundCd
        }
    }
    
}
