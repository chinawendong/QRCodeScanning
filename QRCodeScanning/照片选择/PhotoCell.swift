//
//  PhotoCell.swift
//  PhotoSelectorProductSwift
//
//  Created by 云族佳 on 16/4/22.
//  Copyright © 2016年 温仲斌. All rights reserved.
//

import UIKit

import AssetsLibrary

class PhotoCell: UICollectionViewCell {

    @IBOutlet weak var photoImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    class func collectionViewCell(collectionView : UICollectionView, indexPath: NSIndexPath, asset : ALAsset) -> PhotoCell {
        let item = (collectionView.dequeueReusableCellWithReuseIdentifier("photoCell", forIndexPath: indexPath) as! PhotoCell)
        item.photoImage.image = UIImage.init(CGImage: asset.aspectRatioThumbnail().takeUnretainedValue())
        return item
    }
}
