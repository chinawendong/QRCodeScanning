//
//  HerdViewCell.swift
//  PhotoSelectorProductSwift
//
//  Created by 云族佳 on 16/4/22.
//  Copyright © 2016年 温仲斌. All rights reserved.
//

import UIKit

import AssetsLibrary

class HerdViewCell: UITableViewCell, HerdCollectionViewFlowLayoutDelegate,UICollectionViewDelegate,UICollectionViewDataSource {
    var photoArray = [AnyObject]()

    @IBOutlet weak var collectionView: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       let collectionViewLayout = (self.collectionView.collectionViewLayout as! HerdCollectionViewFlowLayout)
        collectionViewLayout.collectionDelegate = self
        collectionView.registerNib(UINib.init(nibName: "PhotoCell", bundle: nil), forCellWithReuseIdentifier: "photoCell")
    }
    
    func collectionView(row: Int) -> CGSize {
        let asset = photoArray[row] as! ALAsset
        let size : CGSize = asset.defaultRepresentation().dimensions()
        return CGSizeMake((size.width / size.height) * 70, 70)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoArray.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return PhotoCell.collectionViewCell(collectionView, indexPath: indexPath, asset: (photoArray[indexPath.row] as! ALAsset))
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let asset = photoArray[indexPath.row] as! ALAsset
        let image = UIImage.init(CGImage: asset.aspectRatioThumbnail().takeUnretainedValue())
        PopUpView.manager.selectBlock?(selectImage: image)
        PopUpView.manager.dissmiss()
    }
    
    class func HerdViewCells(tableView : UITableView, indexPath: NSIndexPath, identifier : String) -> HerdViewCell {
        let cell = (tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! HerdViewCell)
        let photo = PhotoAlbumMamager.sharedInstance
        
        photo.getCameraFilm { (array) in
            cell.photoArray = array
            cell.collectionView?.reloadData()
        }
        return cell
    }
    


    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
