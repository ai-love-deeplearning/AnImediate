//
//  UIImageExtension.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/09/29.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import AppConfig
import Foundation

public extension UIImage {
    private func chechResizeIsNeeded(image: UIImage, longSide: CGFloat) -> Bool {
        if UIImageToData.maxLongSide == 0 || longSide <= UIImageToData.maxLongSide {
            return false
        }
        return true
    }
    
    func resizeSameAspect() -> UIImage? {
        
        let longSide = max(self.size.width, self.size.height)
        
        /// リサイズ後の画像サイズ
        //private var resizedSize = CGSize()
        if chechResizeIsNeeded(image: self, longSide: longSide) {
            return self
        }
        
        // 長辺に合わせたリサイズ後のサイズを計算
        let aspectRatio = UIImageToData.maxLongSide / longSide
        let newSize = CGSize(width: self.size.width * aspectRatio, height: self.size.height * aspectRatio)
        
        // リサイズ
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        draw(in: CGRect(origin: .zero, size: newSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
}
