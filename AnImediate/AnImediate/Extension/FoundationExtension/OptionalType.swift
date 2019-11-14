//
//  OptionalType.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/09/24.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import Foundation

public protocol OptionalProtocol {
    associatedtype Wrapped
    
    var optional: Wrapped? { get }
}

extension Optional: OptionalProtocol {
    public var optional: Wrapped? {
        return self
    }
}
