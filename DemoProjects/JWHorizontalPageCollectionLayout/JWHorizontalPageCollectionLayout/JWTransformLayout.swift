//
//  JWTransformLayout.swift
//  JWHorizontalPageCollectionLayout
//
//  Created by JiangWang on 2019/8/21.
//  Copyright © 2019 JiangWang. All rights reserved.
//

import UIKit

class JWTransformColletionView: UICollectionView {
    override var contentOffset: CGPoint {
        didSet {
            collectionViewLayout.invalidateLayout()
        }
    }
}

class JWTransformLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attribute = super.layoutAttributesForItem(at: indexPath) else { return nil }
        guard let collectionView = self.collectionView else { return nil }
        let centerX = collectionView.contentOffset.x + collectionView.bounds.width * 0.5
        let scale = 1 - abs(attribute.frame.midX - centerX)/(collectionView.bounds.width * 0.5) * 0.2
        attribute.transform = CGAffineTransform(scaleX: scale, y: scale)
        return attribute
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
        guard let collectionView = self.collectionView else { return nil }
        let newAttributes = attributes.map { (attribute) -> UICollectionViewLayoutAttributes in
            let centerX = collectionView.contentOffset.x + collectionView.bounds.width * 0.5
            let scale = 1 - abs(attribute.frame.midX - centerX)/(collectionView.bounds.width * 0.5) * 0.2
            attribute.transform = CGAffineTransform(scaleX: scale, y: scale)
            return attribute
        }
        return newAttributes
    }
    
}
