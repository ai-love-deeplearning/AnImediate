//
//  SettingCoordinator.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/10/01.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import UIKit

final class SettingCoordinator: NavigationCoordinator {
    let navigationController: UINavigationController
    private let childCoordinators: [Coordinator]
    
    init(presenter: UINavigationController, childCoordinators: [Coordinator]) {
        self.navigationController = presenter
        self.childCoordinators = childCoordinators
        presenter.title = "Setting"
    }
    
    func start() {
        let settingController = StoryboardScene.Setting.initialScene.instantiate()
        //animeListTopViewController.itemSelected = showItemDetail
        navigationController.pushViewController(settingController, animated: false)
        
        childCoordinators.forEach { coordinator in
            coordinator.start()
        }
    }
    
}