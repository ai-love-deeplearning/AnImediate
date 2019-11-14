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
    
    public let homeStore = Store<HomeViewState>(reducer: HomeViewReducer.handleAction,
                                                    state: nil,
                                                    middleware: [])
    
    public let exchangeStore = Store<ExchangeViewState>(reducer: ExchangeViewReducer.handleAction,
                                                      state: nil,
                                                      middleware: [])
    
    public let animeListStore = Store<AnimeListViewState>(reducer: AnimeListViewReducer.handleAction,
                                                        state: nil,
                                                        middleware: [])
    
    public let searchStore = Store<SearchViewState>(reducer: SearchViewReducer.handleAction,
                                                        state: nil,
                                                        middleware: [])
    
    public let settingStore = Store<SettingViewState>(reducer: SettingViewReducer.handleAction,
                                                        state: nil,
                                                        middleware: [])
}
