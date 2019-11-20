//
//  ArrayExtension.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/11/18.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import Foundation

extension Array {
    
    // 配列同士の差集合を得る
    func except<T : Equatable>(_ obj: [T]) -> [T] {
        var ret = [T]()
        
        self.forEach {
            if !obj.contains($0 as! T) {
                ret.append($0 as! T)
            }
        }
        return ret
    }
    
    // 配列同士の積集合を得る
    func intersect<T : Equatable>(_ obj : [T]) -> [T] {
        var ret = [T]()
        
        self.forEach{
            if obj.contains($0 as! T){
                ret.append($0 as! T)
            }
        }
        return ret
    }
    
}
