//
//  FirebaseRequestInjector.swift
//  AppModel
//
//  Created by 川村周也 on 2019/10/08.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import Foundation
import Swinject

public class FirebaseRequestInjector {
    public class func setup(container: Container) {
        container.register(FirebaseRequestable.self) { _ in
            FirebaseRequest()
        }
    }
}
