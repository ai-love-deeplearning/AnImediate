//
//  AnimeListTopCoordinator.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/10/07.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import AppConfig
import UIKit
import Foundation

final class AnimeListTopCoordinator: NavigationCoordinator {
    let navigationController: UINavigationController
    
    init(presenter: UINavigationController) {
        self.navigationController = presenter
        presenter.title = "AnimeListCard"
    }
    
    func start() {
        let animeListTopViewController = StoryboardScene.AnimeListCard.initialScene.instantiate()
        //animeListTopViewController.itemSelected = showItemDetail
        navigationController.pushViewController(animeListTopViewController, animated: false)
    }
    
}
