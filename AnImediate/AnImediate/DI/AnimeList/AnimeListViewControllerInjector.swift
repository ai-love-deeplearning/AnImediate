//
//  AnimeListViewControllerInjector.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/09/29.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import AppModel
import Foundation
import Swinject
import SwinjectStoryboard

final class AnimeListViewControllerInjector {
    class func setup(container: Container) {
        /*
        container.register(P2PSearchActionCreatable.self) { r in
            P2PSearchActionCreator(connector: r.resolve(P2PConnectable.self)!)
        }
        
        container.register(ExchangeAccountActionCreatable.self) { r in
            ExchangeAccountActionCreator(connector: r.resolve(P2PConnectable.self)!)
        }
        
        container.register(ExchangeArchiveActionCreatable.self) { r in
            ExchangeArchiveActionCreator(connector: r.resolve(P2PConnectable.self)!)
        }
        
        container.storyboardInitCompleted(AnimeListVC.self) { r, c in
            c.inject(P2PSearchActionCreator: r.resolve(P2PSearchActionCreatable.self)!, ExchangeAccountActionCreator: r.resolve(ExchangeAccountActionCreatable.self)!, ExchangeArchiveActionCreator: r.resolve(ExchangeArchiveActionCreatable.self)!)
        }*/
    }
}
