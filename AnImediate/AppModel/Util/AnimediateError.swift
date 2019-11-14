//
//  AnimediateError.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/09/22.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import AppConfig

public enum AnimediateError: Error {
    case unknown
}

extension AnimediateError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unknown: return "unknown error happened"
        }
    }
}
