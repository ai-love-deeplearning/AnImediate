//
//  MapDistinct.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/09/24.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

public extension Observable {
    
    /// mapしたObservableをdistinctUntilChangedします
    func mapDistinct <R> (_ transform: @escaping (Element) throws -> R, comparer: @escaping (R, R) throws -> Bool) -> Observable<R> {
        return self.map(transform).distinctUntilChanged(comparer)
    }
    
    /// mapしたObservableをdistinctUntilChangedします
    func mapDistinct <R> (_ transform: @escaping (Element) throws -> R) -> Observable<R> where R: Equatable {
        return self.map(transform).distinctUntilChanged()
    }
}

public extension SharedSequence {
    
    /// mapしたSharedSequenceをdistinctUntilChangedします
    func mapDistinct <R> (_ selector: @escaping (Element) -> R, comparer: @escaping (R, R) -> Bool) -> SharedSequence<SharingStrategy, R> {
        return self.map(selector).distinctUntilChanged(comparer)
    }
    
    /// mapしたSharedSequenceをdistinctUntilChangedします
    func mapDistinct <R> (_ selector: @escaping (Element) -> R) -> SharedSequence<SharingStrategy, R> where R: Equatable {
        return self.map(selector).distinctUntilChanged()
    }
}
