//
//  AnimeHorizontalCollectionView.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/10/11.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import UIKit

class AnimeHorizontalCollectionView: UICollectionView {

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        let layout = UICollectionViewFlowLayout()
        // TODO:- animeList:0.25(4個表示)、Exchange:0.3(3個表示)
        layout.itemSize = CGSize(width: self.bounds.width*0.3, height: self.bounds.height)
        layout.minimumLineSpacing = 0.3
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        
        self.showsHorizontalScrollIndicator = false
        self.collectionViewLayout = layout
    }

}
