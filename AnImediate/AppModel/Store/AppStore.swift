//
//  AppStore.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/09/22.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import ReSwift
import RxSwift

public class AppStore {
    public static let instance = AppStore()

    public let store = Store<AppState>(reducer: AppReducer.appReducer,
                                               state: nil,
                                               middleware: [])
    
    public let exchangeStore = Store<ExchangeViewState>(reducer: ExchangeViewReducer.handleAction,
                                                      state: nil,
                                                      middleware: [])
    
    public let p2pStore = Store<P2PConnectionState>(reducer: P2PReducer.handleAction,
                                                        state: nil,
                                                        middleware: [])
    
}
