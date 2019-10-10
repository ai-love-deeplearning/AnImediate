//
//  LaunchViewControllerInjector.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/10/09.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import AppModel
import Foundation
import Swinject
import SwinjectStoryboard

final class LaunchViewControllerInjector {
    class func setup(container: Container) {
        container.register(LaunchViewActionCreatable.self) { r in
            LaunchViewActionCreator(request: r.resolve(FirebaseRequestable.self)!)
        }
        
        container.storyboardInitCompleted(LaunchViewController.self) { r, c in
            c.inject(LaunchViewActionCreator: r.resolve(LaunchViewActionCreatable.self)!)
        }
    }
}
