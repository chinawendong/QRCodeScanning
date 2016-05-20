//
//  BrowseCell.swift
//  PhotoSelectorProductSwift
//
//  Created by 云族佳 on 16/4/26.
//  Copyright © 2016年 温仲斌. All rights reserved.
//

import UIKit
import AssetsLibrary

class BrowseCell: UICollectionViewCell {

    @IBOutlet weak var photoImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    class func collectionViewCell(collectionView : UICollectionView, indexPath: NSIndexPath, asset : ALAsset) -> BrowseCell {
        let item = (collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! BrowseCell)
        item.photoImage.image = UIImage.init(CGImage: asset.defaultRepresentation().fullScreenImage().takeUnretainedValue())
        return item 
    }
}
