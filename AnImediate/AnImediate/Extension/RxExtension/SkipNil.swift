//
//  SkipNil.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/09/24.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

public extension Observable where Element: OptionalProtocol {
    
    /// nilをスキップします
    func skipNil() -> Observable<Element.Wrapped> {
        return flatMap { Observable<Element.Wrapped>.from(optional: $0.optional) }
    }
}

public extension SharedSequence where Element: OptionalProtocol {
    
    /// nilをスキップします
    func skipNil() -> SharedSequence<SharingStrategy, Element.Wrapped> {
        return flatMap { SharedSequence<SharingStrategy, Element.Wrapped>.from(optional: $0.optional) }
    }
}
