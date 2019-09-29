//
//  ProfileEditVCSource.swift
//  AppConfig
//
//  Created by 川村周也 on 2019/09/29.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import Foundation

protocol AutoActionable {}

protocol AutoViewReducerable {}

protocol AutoViewStatable {}

protocol AutoVCInjectorable {}

protocol ProfileEditView: AutoActionable {}

protocol ProfileEdit: AutoViewReducerable, AutoViewStatable, AutoVCInjectorable  {}
