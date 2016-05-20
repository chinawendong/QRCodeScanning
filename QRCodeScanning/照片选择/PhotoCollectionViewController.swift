//
//  PhotoCollectionViewController.swift
//  PhotoSelectorProductSwift
//
//  Created by 云族佳 on 16/4/22.
//  Copyright © 2016年 温仲斌. All rights reserved.
//

import UIKit

import AssetsLibrary

private let reuseIdentifier = "groupCell"

class PhotoCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var group : ALAssetsGroup?
    var itemArray = [AnyObject]()
    var selectArray = [String:String]()
    let toolbar = UIToolbar.init()
    var leftButton = UIBarButtonItem.init(title: "预览", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
    var rigthButton = UIBarButtonItem.init(title: "发送", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
    var cententButton : UIBarButtonItem?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        self.collectionView!.backgroundColor = UIColor.whiteColor()
        // Register cell classes
        self.collectionView!.registerNib(UINib.init(nibName: "GroupPhotoCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        if self.group != nil {
            self.title = (self.group!.valueForProperty(ALAssetsGroupPropertyName) as! String)
            PhotoAlbumMamager.sharedInstance.getAssetArrayWithGroup(self.group) { (array) in
                self.itemArray = array.reverse()
                self.collectionView?.reloadData()
            }
        }else {
            self.title = "相机胶卷"
            PhotoAlbumMamager.sharedInstance.getCameraFilm({ (array) in
                self.itemArray = array.reverse()
                self.collectionView?.reloadData()
            })
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.dissmiss))
        //        self.setToolbar()
        // Do any additional setup after loading the view.
    }
    
    func setToolbar() {
        self.collectionView?.contentInset = UIEdgeInsetsMake(0, 0, 44, 0)
        self.view.addSubview(toolbar)
        self.cententButton = UIBarButtonItem.init(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        cententButton!.title = "\(self.selectArray.count)"
        cententButton!.tintColor = UIColor.init(red: 37 / 255.0, green: 167 / 255.0, blue: 44 / 256.0, alpha: 1)
        
        rigthButton.target = self
        rigthButton.action = #selector(sendSelectImage)
        
        let spbutton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        toolbar.setItems([leftButton,spbutton,spbutton,cententButton!,spbutton,spbutton,rigthButton], animated: true)
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        let leftConstraint = NSLayoutConstraint(item: toolbar,
                                                attribute: .Right,
                                                relatedBy: .Equal,
                                                toItem: self.view,
                                                attribute: .Right,
                                                multiplier: 1,
                                                constant: 0)
        
        let bottomConstraint = NSLayoutConstraint(item: toolbar,
                                                  attribute: .Bottom,
                                                  relatedBy: .Equal,
                                                  toItem: self.view,
                                                  attribute: .Bottom,
                                                  multiplier: 1,
                                                  constant: 0.0)
        let rigthConstraint = NSLayoutConstraint(item: toolbar,
                                                 attribute: .Left,
                                                 relatedBy: .Equal,
                                                 toItem: self.view,
                                                 attribute: .Left,
                                                 multiplier: 1,
                                                 constant: 0.0)
        let heightConstraint = NSLayoutConstraint(item: toolbar,
                                                  attribute: .Height,
                                                  relatedBy: .Equal,
                                                  toItem: nil,
                                                  attribute: .NotAnAttribute,
                                                  multiplier: 1,
                                                  constant: 44)
        
        self.view.addConstraints([rigthConstraint,leftConstraint,bottomConstraint,heightConstraint])
        
    }
    
    func dissmiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        
        return (itemArray.count)
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! GroupPhotoCell)
        
        let asset = itemArray[indexPath.row] as! ALAsset
        cell.imageV.image = UIImage.init(CGImage: asset.aspectRatioThumbnail().takeUnretainedValue())
        
        if (selectArray["\(indexPath.row)"] != nil) {
            cell.selectType = GroupPhotoCellImageType.Select
        }else {
            cell.selectType = GroupPhotoCellImageType.Nome
        }
        
        cell.selectImageBlock = {()->Void in
            if (self.selectArray["\(indexPath.row)"] != nil) {
                self.selectArray.removeValueForKey("\(indexPath.row)")
            }else {
                self.selectArray["\(indexPath.row)"] = "\(indexPath.row)"
            }
            self.cententButton!.title = "\(self.selectArray.count)"
        }
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //        let flowLayout = BrowseCollectionViewLayout()
        //
        //        let beowseView = PhotoBrowseViewController(collectionViewLayout : flowLayout)
        //        flowLayout.collectionDelegate = beowseView
        //        beowseView.selectArray = self.selectArray
        //        beowseView.itemArray = self.itemArray
        //        beowseView.selectIndx = indexPath
        //        beowseView.getSelectChange { (array) in
        //            self.selectArray = array
        //            self.collectionView?.reloadData()
        //            self.cententButton!.title = "\(self.selectArray.count)"
        //        }
        //        self.navigationController?.pushViewController(beowseView, animated: true)
        let asset = itemArray[indexPath.row] as! ALAsset
        PopUpView.manager.selectImagesBlock!(selectImages: UIImage.init(CGImage: asset.defaultRepresentation().fullScreenImage().takeUnretainedValue()))
        self.dissmiss()
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake((CGRectGetWidth((self.collectionView?.bounds)!) - 3) / 4, (CGRectGetWidth((self.collectionView?.bounds)!) - 3) / 4)
    }
    
    func sendSelectImage() {
        //        PopUpView.manager.selectImagesBlock!(selectImages: self.getSelectImages() )
        //        self.dissmiss()
    }
    
    func getSelectImages() -> [AnyObject] {
        var images = [AnyObject]()
        for string in self.selectArray.keys.reverse() {
            images.append(self.itemArray[Int(string)!])
        }
        return images
    }
    
    //     MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return false
     }
     
     override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
     return false
     }
     
     override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
     
     }
     */
    
}
