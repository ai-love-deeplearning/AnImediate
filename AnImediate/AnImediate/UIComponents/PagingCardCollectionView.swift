//
//  PagingCardCollectionView.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/11/13.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import UIKit

class PagingCardCollectionView: UICollectionView {

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        let layout = PagingCardCollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: self.bounds.width*0.7, height: self.bounds.height)
        layout.minimumInteritemSpacing = self.bounds.height
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)
        
        self.showsHorizontalScrollIndicator = false
        self.collectionViewLayout = layout
    }

}

class PagingCardCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return proposedContentOffset }

        // sectionInset を考慮して表示領域を拡大する
        let expansionMargin = sectionInset.left + sectionInset.right
        let expandedVisibleRect = CGRect(x: collectionView.contentOffset.x - expansionMargin,
                                          y: 0,
                                          width: collectionView.bounds.width + (expansionMargin * 2),
                                          height: collectionView.bounds.height)

        // 表示領域の layoutAttributes を取得し、X座標でソートする
        guard let targetAttributes = layoutAttributesForElements(in: expandedVisibleRect)?
            .sorted(by: { $0.frame.minX < $1.frame.minX }) else { return proposedContentOffset }

        let nextAttributes: UICollectionViewLayoutAttributes?
        if velocity.x == 0 {
            // スワイプせずに指を離した場合は、画面中央から一番近い要素を取得する
            nextAttributes = layoutAttributesForNearbyCenterX(in: targetAttributes, collectionView: collectionView)
        } else if velocity.x > 0 {
            // 左スワイプの場合は、最後の要素を取得する
            nextAttributes = targetAttributes.last
        } else {
            // 右スワイプの場合は、先頭の要素を取得する
            nextAttributes = targetAttributes.first
        }
        guard let attributes = nextAttributes else { return proposedContentOffset }

        if attributes.representedElementKind == UICollectionView.elementKindSectionHeader {
            // ヘッダーの場合は先頭の座標を返す
            return CGPoint(x: 0, y: collectionView.contentOffset.y)
        } else {
            // 画面左端からセルのマージンを引いた座標を返して画面中央に表示されるようにする
            let cellLeftMargin = (collectionView.bounds.width - attributes.bounds.width) * 0.5
            return CGPoint(x: attributes.frame.minX - cellLeftMargin, y: collectionView.contentOffset.y)
        }
    }
    
    // 画面中央に一番近いセルの attributes を取得する
    private func layoutAttributesForNearbyCenterX(in attributes: [UICollectionViewLayoutAttributes], collectionView: UICollectionView) -> UICollectionViewLayoutAttributes? {
        var nearByCenter = attributes.first
        var minDistance = abs(collectionView.center.x - attributes.first!.center.x)
        for attribute in attributes {
            print(attribute.center.x)
            if abs(collectionView.center.x - attribute.center.x) < minDistance {
                minDistance = abs(collectionView.center.x - attribute.center.x)
                nearByCenter = attribute
            }
        }
        return attributes[1]
    }
}
