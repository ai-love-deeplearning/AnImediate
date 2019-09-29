//
//  UIStyleExtension.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/09/29.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import Foundation
import SwiftRichString

extension UIFont {
    
    struct Hiragino {
        private init() {}
        
        static func font(size: CGFloat, style: Style = .regular) -> UIFont {
            let fontName = "HiraginoSans-\(style)"
            return UIFont(name: fontName, size: size)!
        }
        
        enum Style: CustomStringConvertible {
            case regular, bold
            
            var description: String {
                switch self {
                case .regular:
                    return "W3"
                case .bold:
                    return "W6"
                }
            }
        }
    }
    
    struct RobotoCondensed {
        private init() {}
        static func font(size: CGFloat, style: Style = .light) -> UIFont {
            let fontName = "RobotoCondensed-\(style)"
            return UIFont(name: fontName, size: size)!
        }
        
        enum Style: CustomStringConvertible {
            case light, regular
            
            var description: String {
                switch self {
                case .light:
                    return "Light"
                case .regular:
                    return "Regular"
                }
            }
        }
    }
}
