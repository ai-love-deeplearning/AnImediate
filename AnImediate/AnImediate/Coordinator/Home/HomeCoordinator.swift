//
//  HomeCoordinator.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/10/01.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import UIKit

final class HomeCoordinator: NavigationCoordinator {
    let navigationController: UINavigationController
    private let childCoordinators: [Coordinator]
    
    init(presenter: UINavigationController, childCoordinators: [Coordinator]) {
        self.navigationController = presenter
        self.childCoordinators = childCoordinators
        presenter.title = "Home"
    }
    
    func start() {
        let homeController = StoryboardScene.Home.initialScene.instantiate()
        //animeListTopViewController.itemSelected = showItemDetail
        navigationController.pushViewController(homeController, animated: false)
        
        childCoordinators.forEach { coordinator in
            coordinator.start()
        }
    }
    
}
