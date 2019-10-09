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
        
        // MARK:- Module(Request)
        P2PConnectionInjector.setup(container: defaultContainer)
        FirebaseRequestInjector.setup(container: defaultContainer)
        
        // MARK:- Home
        HomeViewControllerInjector.setup(container: defaultContainer)
        HomeArchiveListViewControllerInjecter.setup(container: defaultContainer)
        ProfileEditViewControllerInjecter.setup(container: defaultContainer)
        
        // MARK:- Exchange
        ExchangeViewControllerInjecter.setup(container: defaultContainer)
        ExchangeAcceptViewControllerInjector.setup(container: defaultContainer)
        
        // MARK:-  AnimeList
        AnimeListTopViewControllerInjector.setup(container: defaultContainer)
        
        // MARK:-  Search
        SearchViewControllerInjector.setup(container: defaultContainer)
        
        // MARK:-  Setting
        SettingViewControllerInjector.setup(container: defaultContainer)
    }
}
