//
//  TabBarCoordinator.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/10/01.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import Foundation

protocol TabBarCoordinator: Coordinator {
    var tabBarController: UITabBarController { get }
}

extension TabBarCoordinator {
    var presenter: UIViewController {
        return tabBarController as UIViewController
    }
}
