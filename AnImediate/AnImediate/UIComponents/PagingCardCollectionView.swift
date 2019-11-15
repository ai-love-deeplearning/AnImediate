//
//  PagingCardCollectionView.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/11/13.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import AppConfig
import UIKit

class PagingCardCollectionView: UICollectionView {

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        let layout = PagingCardCollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: ScreenConfig.mainBoundSize.width-56, height: self.bounds.height*0.8)
        layout.minimumInteritemSpacing = self.bounds.height
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 12, left: 28, bottom: 12, right: 28)
        
        self.showsHorizontalScrollIndicator = false
        self.collectionViewLayout = layout
        self.decelerationRate = .fast
    }

}

class PagingCardCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    private var layoutAttributesForPaging: [UICollectionViewLayoutAttributes]?
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return proposedContentOffset }
        guard let targetAttributes = layoutAttributesForPaging else { return proposedContentOffset }

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
        var minDistance = abs(collectionView.center.x - (attributes.first!.center.x - collectionView.contentOffset.x))
        for attribute in attributes {
            if abs(collectionView.center.x - (attribute.center.x - collectionView.contentOffset.x)) < minDistance {
                minDistance = abs(collectionView.center.x - (attribute.center.x - collectionView.contentOffset.x))
                nearByCenter = attribute
            }
        }
        return nearByCenter
    }
    
    // UIScrollViewDelegate scrollViewWillBeginDragging から呼ぶ
    func prepareForPaging() {
        // 1ページずつページングさせるために、あらかじめ表示されている attributes の配列を取得しておく
        guard let collectionView = collectionView else { return }
        let expansionMargin = sectionInset.left + sectionInset.right
        let expandedVisibleRect = CGRect(x: collectionView.contentOffset.x - expansionMargin,
                                          y: 0,
                                          width: collectionView.bounds.width + (expansionMargin * 2),
                                          height: collectionView.bounds.height)
        layoutAttributesForPaging = layoutAttributesForElements(in: expandedVisibleRect)?.sorted { $0.frame.minX < $1.frame.minX }
    }
}
