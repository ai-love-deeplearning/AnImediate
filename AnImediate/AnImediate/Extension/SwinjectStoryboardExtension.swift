//
//  SwinjectStoryboardExtension.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/09/27.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import AppModel
import Foundation
import Swinject
import SwinjectStoryboard

extension SwinjectStoryboard {
    class func setup() {
        
        P2PConnectionInjector.setup(container: defaultContainer)
        
        ExchangeViewControllerInjecter.setup(container: defaultContainer)
    }
}
