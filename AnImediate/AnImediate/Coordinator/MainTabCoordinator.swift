//
//  MainTabCoordinator.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/10/01.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import Foundation

final class MainTabCoordinator: TabBarCoordinator {
    
    let tabBarController: UITabBarController
    private let childCoordinators: [Coordinator]
    
    init(presenter: UITabBarController, childCoordinators: [Coordinator]) {
        self.tabBarController = presenter
        self.childCoordinators = childCoordinators
    }
    
    func start() {
        childCoordinators.forEach { coordinator in
            coordinator.start()
        }
        tabBarController.setViewControllers(
            childCoordinators.map { $0.presenter },
            animated: false
        )
    }
}
