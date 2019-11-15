//
//  UIColorExtension.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/06/26.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import UIKit

extension UIColor {
    
    class func rgba(red: Int, green: Int, blue: Int, alpha: CGFloat) -> UIColor{
        return UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
    
    class func deepMagenta()->UIColor{
        let color = rgba(red: 210, green: 0, blue: 100, alpha: 1)
        return color
    }
    
    class func whiteSmoke()->UIColor{
        let color = rgba(red: 245, green: 245, blue: 245, alpha: 1)
        return color
    }

}

// Color Assets
extension UIColor {
    // MainThema: #F00F87
    class var MainThema: UIColor {
        return UIColor(named: "MainThema") ?? .black
    }
    
    // LightThema: #FEE6F3
    class var LightThema: UIColor {
        return UIColor(named: "LightThema") ?? .black
    }
    
    // TextThema: #E12387
    class var TextThema: UIColor {
        return UIColor(named: "TextThema") ?? .black
    }
    
    // TextBlack: #1D0010
    class var TextBlack: UIColor {
        return UIColor(named: "TextThema") ?? .black
    }
    
    // TextGray: #8B8789
    class var TextGray: UIColor {
        return UIColor(named: "TextGray") ?? .black
    }
    
    // TextLightGray: #BFB8BB
    class var TextLightGray: UIColor {
        return UIColor(named: "TextLightGray") ?? .black
    }
    
    // LineMedium: #C4B3BC
    class var LineMedium: UIColor {
        return UIColor(named: "LineMedium") ?? .black
    }
    
    // LineLight: #E8D9E1
    class var LineLight: UIColor {
        return UIColor(named: "LineLight") ?? .black
    }
    
}
