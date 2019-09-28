//
//  ExchangeAcceptViewControllerInjector.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/09/28.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import AppModel
import Foundation
import Swinject
import SwinjectStoryboard

final class ExchangeAcceptViewControllerInjector {
    class func setup(container: Container) {
        container.register(P2PDisconnectActionCreatable.self) { r in
            P2PDisconnectActionCreator(connector: r.resolve(P2PConnectable.self)!)
        }
        
        container.register(ExchangeArchiveActionCreatable.self) { r in
            ExchangeArchiveActionCreator(connector: r.resolve(P2PConnectable.self)!)
        }
        
        container.storyboardInitCompleted(ExchangeAcceptVC.self) { r, c in
            c.inject(P2PDisconnectActionCreator: r.resolve(P2PDisconnectActionCreatable.self)!, ExchangeArchiveActionCreator: r.resolve(ExchangeArchiveActionCreatable.self)!)
        }
    }
}
