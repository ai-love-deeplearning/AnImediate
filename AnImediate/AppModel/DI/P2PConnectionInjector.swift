//
//  P2PConnectionInjector.swift
//  AppModel
//
//  Created by 川村周也 on 2019/09/27.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import Foundation
import Swinject

public class P2PConnectionInjector {
    public class func setup(container: Container) {
        container.register(P2PConnectable.self) { _ in
            P2PConnectivity()
        }
    }
}
