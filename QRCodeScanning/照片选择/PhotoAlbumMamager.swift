//
//  PhotoAlbumMamager.swift
//  PhotoSelectorProductSwift
//
//  Created by 云族佳 on 16/4/22.
//  Copyright © 2016年 温仲斌. All rights reserved.
//

import UIKit
import AssetsLibrary

public typealias ReloadGroupArrayBlock = (array : [ALAssetsGroup])->Void
public typealias ReloadCameraFilmArrayBlock = (array : [AnyObject])->Void
public typealias ReloadGroupArrayErrorBlock = (error : NSError)->Void

class PhotoAlbumMamager: NSObject {
    static let sharedInstance = PhotoAlbumMamager()
    let assetsLibrary = ALAssetsLibrary.init()
    
    var groupArray = [ALAssetsGroup]()
    
    override init() {
        super.init()
        
     }
    
    func getAlbumGroups(reloadGroupArrayBlock : ReloadGroupArrayBlock?, reloadGroupArrayErrorBlock : ReloadGroupArrayErrorBlock?) -> Void {
        self.groupArray.removeAll()
        self.assetsLibrary.enumerateGroupsWithTypes(ALAssetsGroupAll, usingBlock: { (group, stop) in
            if (group != nil && group.numberOfAssets() != 0)  {
                
                self.groupArray.append(group)
            }else {
                
                reloadGroupArrayBlock?(array: self.groupArray)
            }
            }, failureBlock: { (error) in
                reloadGroupArrayErrorBlock?(error: error!)
        })
    }
    
    func getCameraFilm(reloadCameraFilmArrayBlock:ReloadCameraFilmArrayBlock?) {
            getAlbumGroups({ (array) in
                for group in (array as [ALAssetsGroup]){
                    if (group.valueForProperty(ALAssetsGroupPropertyType) as! NSNumber).integerValue == 16 {
                        
                        var cameraFilmArray = [ALAsset]()
                        
                        group.enumerateAssetsUsingBlock({ (asset, idx, stop) in
                            if asset != nil {
                                cameraFilmArray.append(asset)
                            }else {
                                reloadCameraFilmArrayBlock?(array: cameraFilmArray)
                            }
                        })
                        break
                    }
                }
                }, reloadGroupArrayErrorBlock: nil)
    }
    
    func getAssetArrayWithGroup(group : ALAssetsGroup?, reloadCameraFilmArrayBlock:ReloadCameraFilmArrayBlock?) {
        var cameraFilmArray = [ALAsset]()
        group?.enumerateAssetsUsingBlock({ (asset, idx, stop) in
            if asset != nil {
                cameraFilmArray.append(asset)
            }else {
                reloadCameraFilmArrayBlock?(array: cameraFilmArray)
            }
        })
    }
    func pushPhotoViewController(parentView : UIView) {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 1
        flowLayout.minimumInteritemSpacing = 1
        let photoItem = PhotoCollectionViewController(collectionViewLayout : flowLayout)
        let photoGroup = PhotoGroupViewController()
        
        let nav = UINavigationController.init(rootViewController: photoGroup)
        nav.navigationBar.barStyle = UIBarStyle.Black
        
        nav.setViewControllers([photoGroup,photoItem], animated: true)
        
        nav.navigationBar.tintColor = UIColor.whiteColor()
        
        let viewController = parentView.window?.rootViewController
        viewController!.presentViewController(nav, animated: true, completion: nil)
    }
    
    func getParentViewController(parentView : UIView) -> UIViewController {
        var nextResponder = parentView.nextResponder()
        while !nextResponder!.isKindOfClass(UIViewController) {
            nextResponder = nextResponder!.nextResponder()
        }
        return (nextResponder as! UIViewController)
    }
    
}
