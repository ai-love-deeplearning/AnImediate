//
//  AnimeGenreCollectionView.swift
//  AnImediate
//
//  Created by 前田陸 on 2019/11/17.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import AppConfig
import UIKit

class AnimeGenreCollectionView: UICollectionView {

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: ScreenConfig.mainBoundSize.width, height: 128)
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        self.showsHorizontalScrollIndicator = false
        self.collectionViewLayout = layout
    }
    
}
