//
//  P2PError.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/09/24.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import AppConfig

public struct P2PError: Error, Equatable {
    
    public enum ErrorType {
        case common
        case noReply // 無限に接続できないとき
    }
    
    public let statusCode: Int
    public let messageID: String?
    public let title: String?
    public let errorMessage: String?
    public var type: ErrorType {
        switch statusCode {
        case ErrorCode.error001:
            return .common
        case ErrorCode.error002, ErrorCode.error003:
            return .noReply
        default:
            return .common
        }
    }
    
    public init?(statusCode: Int, resCd: String, msgId: String?, msgTitle: String?, msg: String?) {
        guard resCd == "error" else { return nil }
        
        self.statusCode = statusCode
        self.messageID = msgId
        
        switch statusCode {
        case ErrorCode.unexpectedError:
            self.title = "unexpectedError"
            self.errorMessage = "unexpectedError"
        case ErrorCode.error001:
            self.title = msgTitle ?? "error001"
            self.errorMessage = msg ?? "error001"
        case ErrorCode.error002:
            self.title = msgTitle ?? "error002"
            self.errorMessage = msg ?? "error002"
        default:
            self.title = msgTitle ?? "error"
            self.errorMessage = msg
        }
    }
    
    public init(statusCode: Int, msg: String? = nil) {
        self.init(statusCode: statusCode, resCd: "error", msgId: nil, msgTitle: nil, msg: msg)!
    }
    
    private init(statusCode: Int, msgId: String?, msgTitle: String?, msg: String?) {
        self.statusCode = statusCode
        self.messageID = msgId
        self.title = msgTitle
        self.errorMessage = msg
    }


}
