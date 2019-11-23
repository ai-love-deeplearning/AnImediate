//
//  P2PError.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/09/24.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import AppConfig

public enum P2PError: Error {
    case unknown
    case timeout
    case accountDataEmpty
    case archiveDataEmpty
    case accountSendFailed
    case archiveSendFailed
    case sessionNil
    case notificationError
}

extension P2PError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unknown: return "unknown error happened"
        case .timeout: return "connection timeout"
        case .accountDataEmpty: return "account data is empty"
        case .archiveDataEmpty: return "archive data is empty"
        case .accountSendFailed: return "正常にアカウント情報の送信が行われませんでした"
        case .archiveSendFailed: return "正常にアーカイブ情報の送信が行われませんでした"
        case .sessionNil: return "session is nil"
        case .notificationError: return "Notification error"
        }
    }
}
