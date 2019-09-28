//
//  SwinjectStoryboardExtension.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/09/27.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import AppModel
import Foundation
import Swinject
import SwinjectStoryboard

extension SwinjectStoryboard {
    class func setup() {
        
        // MARK:-  Home
        HomeViewControllerInjector.setup(container: defaultContainer)
        
        // MARK:- Exchange
        ExchangeViewControllerInjecter.setup(container: defaultContainer)
        P2PConnectionInjector.setup(container: defaultContainer)
        ExchangeAcceptViewControllerInjector.setup(container: defaultContainer)
        
        // MARK:-  AnimeList
        AnimeListViewControllerInjector.setup(container: defaultContainer)
        
        // MARK:-  Search
        SearchViewControllerInjector.setup(container: defaultContainer)
        
        // MARK:-  Setting
        SettingViewControllerInjector.setup(container: defaultContainer)
    }
}
