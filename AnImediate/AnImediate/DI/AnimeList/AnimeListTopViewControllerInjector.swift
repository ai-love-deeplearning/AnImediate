//
//  AnimeListTopViewControllerInjector.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/09/29.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import AppModel
import Foundation
import Swinject
import SwinjectStoryboard

final class AnimeListTopViewControllerInjector {
    class func setup(container: Container) {
        container.register(AnimeListTopViewActionCreatable.self) { r in
            AnimeListTopViewActionCreator(request: r.resolve(FirebaseRequestable.self)!)
        }
        
        container.storyboardInitCompleted(AnimeListTopVC.self) { r, c in
            c.inject(AnimeListTopViewActionCreator: r.resolve(AnimeListTopViewActionCreatable.self)!)
        }
    }
}
