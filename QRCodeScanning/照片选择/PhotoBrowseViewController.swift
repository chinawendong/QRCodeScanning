//
//  PhotoBrowseViewController.swift
//  PhotoSelectorProductSwift
//
//  Created by 云族佳 on 16/4/26.
//  Copyright © 2016年 温仲斌. All rights reserved.
//

import UIKit

import AssetsLibrary

enum ImageType {
    case Original
    case None
}

private let reuseIdentifier = "Cell"

typealias GetBysBlock = (Int64)->Void

class PhotoBrowseViewController: UICollectionViewController,HerdCollectionViewFlowLayoutDelegate {
    var itemArray = [AnyObject]()
    var selectArray = [String:String]()
    var selectIndx : NSIndexPath?
    let toolbar = UIToolbar.init()
    var leftButton = UIBarButtonItem.init(title: "○原图", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
    var rigthButton = UIBarButtonItem.init(title: "发送", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
    var navRigthButton = UIButton.init(type: UIButtonType.Custom)
    var imageType : ImageType = .None
    var getBysBlock : GetBysBlock?
    var currIdx = 0
    var selectBlock : ((array : [String : String])->Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        self.collectionView!.registerNib(UINib.init(nibName: "BrowseCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.pagingEnabled = true
        self.setToolbar()
        
        navRigthButton.bounds = CGRectMake(0, 0, 20, 20)
        navRigthButton.setImage(UIImage.init(named: "Unknown"), forState: UIControlState.Normal)
        navRigthButton.addTarget(self, action: #selector(selectAction), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: navRigthButton)
        // Do any additional setup after loading the view.
        
//        self.selectBlock?(array : self.selectArray)
        
    }
    
    func dissmiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func getSelectChange(selectBlock : ([String : String]->Void)?) {
        self.selectBlock = selectBlock
    }
    
    func selectAction() {
        if (self.selectArray["\(currIdx)"] != nil) {
            self.selectArray.removeValueForKey("\(currIdx)")
            self.imageType = .None
            navRigthButton.setImage(UIImage.init(named: "Unknown"), forState: UIControlState.Normal)
        }else {
            self.selectArray["\(currIdx)"] = "\(currIdx)"
            self.imageType = .Original
            navRigthButton.setImage(UIImage.init(named: "Unknown-1"), forState: UIControlState.Normal)
        }
        self.selectBlock?(array: self.selectArray)
    }
    
    func setToolbar() {
        self.collectionView?.contentInset = UIEdgeInsetsMake(0, 0, 44, 0)
        self.view.addSubview(toolbar)
        
        rigthButton.target = self
        rigthButton.action = #selector(sendSelectImage)
        
        leftButton.target = self
        leftButton.action = #selector(original)
        
        toolbar.barStyle = .Black
        let spbutton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        toolbar.setItems([leftButton,spbutton,spbutton,spbutton,spbutton,rigthButton], animated: true)
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
    
    func getImageBys(bys : Int64) ->Void {
        let size = Float(bys) / (1024.0 * 1024.0)
        if size < 1 {
            self.leftButton.title = "◎原图" + "(\(String(format: "%.f",size * 1024))k)"
        }else {
            self.leftButton.title = "◎原图" + "(\(String(format: "%.2f",size))M)"
        }
    }
    
    func original() {
        if self.imageType == .None {
            self.imageType = .Original
            let asset = (itemArray[currIdx] as! ALAsset)
            self.getImageBys(asset.defaultRepresentation().size())
        }else {
            self.imageType = .None
            self.leftButton.title = "○原图"
        }
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let idx : Int = (selectIndx?.row)!
        let offset = CGRectGetWidth((self.collectionView?.bounds)!)
        self.collectionView?.setContentOffset(CGPointMake(CGFloat(Int(idx)) * offset, 0), animated: false)
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
        return itemArray.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return BrowseCell.collectionViewCell(collectionView, indexPath: indexPath, asset: (itemArray[indexPath.row] as! ALAsset))
    }
    
    func collectionView(row:Int) -> CGSize {
        return CGSizeMake(CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 64 - 44)
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let idx = Int((scrollView.contentOffset.x / CGRectGetWidth(self.view.bounds)))
        
        if (selectArray[String(format: "%.f", (scrollView.contentOffset.x / CGRectGetWidth(self.view.bounds)))] != nil) {
            navRigthButton.setImage(UIImage.init(named: "Unknown-1"), forState: UIControlState.Normal)
        }else {
            navRigthButton.setImage(UIImage.init(named: "Unknown"), forState: UIControlState.Normal)
        }
        if self.imageType == .Original {
            let asset = (itemArray[idx] as! ALAsset)
            self.getImageBys(asset.defaultRepresentation().size())
        }
        currIdx = idx
    }
    
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    }
}
