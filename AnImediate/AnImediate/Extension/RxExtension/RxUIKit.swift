//
//  RxUIKit.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/09/28.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import RxCocoa
import RxSwift

extension SharedSequenceConvertibleType {
    
    func coolTime() -> SharedSequence<SharingStrategy, E> {
        return throttle(RxTimeInterval(0.3), latest: false)
    }
}
