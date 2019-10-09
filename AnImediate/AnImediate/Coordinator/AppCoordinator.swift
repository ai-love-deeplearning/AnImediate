//
//  AppCoordinator.swift
//  AppModel
//
//  Created by 川村周也 on 2019/10/01.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import AppConfig
import AppModel
import Foundation
import ReSwift

final class AppCoordinator {
    private let window: UIWindow
    private let rootCoordinator: Coordinator
    
    init(window: UIWindow, rootCoordinator: Coordinator) {
        self.window = window
        self.rootCoordinator = rootCoordinator
    }
    
    func start() {
        rootCoordinator.start()
        window.rootViewController = rootCoordinator.presenter
        window.makeKeyAndVisible()
    }
}
