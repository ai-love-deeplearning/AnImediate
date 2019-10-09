//
//  AnimeListCoordinator.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/10/01.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import AppConfig
import UIKit
import Foundation

final class AnimeListCoordinator: NavigationCoordinator {
    let navigationController: UINavigationController
    private let childCoordinators: [Coordinator]
    
    init(presenter: UINavigationController, childCoordinators: [Coordinator]) {
        self.navigationController = presenter
        self.childCoordinators = childCoordinators
        presenter.title = "AnimeList"
    }
    
    func start() {
        let animeListTopViewController = StoryboardScene.AnimeList.initialScene.instantiate()
        //animeListTopViewController.itemSelected = showItemDetail
        navigationController.pushViewController(animeListTopViewController, animated: false)
        childCoordinators.forEach { coordinator in
            coordinator.start()
        }
    }

}
