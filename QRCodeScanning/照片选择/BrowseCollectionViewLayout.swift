//
//  BrowseCollectionViewLayout.swift
//  PhotoSelectorProductSwift
//
//  Created by 云族佳 on 16/4/26.
//  Copyright © 2016年 温仲斌. All rights reserved.
//

import UIKit

class BrowseCollectionViewLayout: UICollectionViewLayout {
    var itemsArray = [UICollectionViewLayoutAttributes]()
    var collectionDelegate : HerdCollectionViewFlowLayoutDelegate?
    var sizeWith : CGFloat = 0.0
    
    override func prepareLayout() {
        let countItems : Int = (self.collectionView?.numberOfItemsInSection(0))!
        
        for index in 0..<countItems {
            let size = collectionDelegate?.collectionView(index)
            
            let indexPath = NSIndexPath.init(forRow: index, inSection: 0)
            let layoutAttribute = UICollectionViewLayoutAttributes.init(forCellWithIndexPath: indexPath)
            layoutAttribute.zIndex = index
            layoutAttribute.frame = CGRectMake(self.sizeWith, 0, (size?.width)!, (size?.height)!)
            self.sizeWith += size!.width
            itemsArray.append(layoutAttribute)
        }
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return itemsArray
    }
    
    override func collectionViewContentSize() -> CGSize {
        return CGSizeMake(sizeWith, 0)
    }

}
