//
//  AnimeListVCSource.swift
//  AppConfig
//
//  Created by 川村周也 on 2019/10/04.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import Foundation

protocol AnimeList: AutoVCInjectorable, AutoViewStatable, AutoViewReducerable {}

protocol AnimeListTopView: AutoActionable, AutoStatable, AutoReducerable, AutoActionCreatable {}

protocol AnimeListTableView: AutoActionable, AutoStatable, AutoReducerable {}
