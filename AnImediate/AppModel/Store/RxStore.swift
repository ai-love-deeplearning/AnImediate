//
//  RxStore.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/09/22.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import Foundation
import ReSwift
import RxCocoa
import RxSwift

public class RxStore<AnyStateType>: StoreSubscriber where AnyStateType: StateType {
    
    public lazy var stateDriver: Driver<AnyStateType> = {
        self.stateRelay.asDriver()
    }()
    public var state: AnyStateType { return stateRelay.value }
    
    private let stateRelay: BehaviorRelay<AnyStateType>
    private let store: Store<AnyStateType>
    
    public init(store: Store<AnyStateType>) {
        self.store = store
        self.stateRelay = BehaviorRelay(value: store.state)
        self.store.subscribe(self)
    }
    
    deinit {
        self.store.unsubscribe(self)
    }
    
    public func newState(state: AnyStateType) {
        self.stateRelay.accept(state)
    }
    
    public func dispatch(_ action: Action) {
        store.dispatch(action)
    }
    
    public func dispatch(_ actionCreatorProvider: @escaping (AnyStateType, ReSwift.Store<AnyStateType>) -> Action?) {
        store.dispatch(actionCreatorProvider)
    }
    
    public func dispatch(_ asyncActionCreatorProvider: @escaping (AnyStateType, ReSwift.Store<AnyStateType>, @escaping (((AnyStateType, ReSwift.Store<AnyStateType>) -> Action?) -> Swift.Void)) -> Swift.Void) {
        store.dispatch(asyncActionCreatorProvider)
    }
}
