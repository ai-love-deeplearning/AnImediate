//
//  StringExtension.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/09/28.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

public extension String {
    var isNotEmpty: Bool {
        return !isEmpty
    }
}

public extension String {
    func checkRegularExpression(pattern: String, options: NSRegularExpression.Options = []) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: options)
            return regex.matches(in: self, options: .reportCompletion, range: NSRange(location: 0, length: self.count)).isNotEmpty
        } catch {
            return false
        }
    }
}
