//
//  PopUpView.swift
//  PhotoSelectorProductSwift
//
//  Created by 云族佳 on 16/4/22.
//  Copyright © 2016年 温仲斌. All rights reserved.
//

import UIKit

import AssetsLibrary

typealias SelectBlock = (selectImage : UIImage)->Void
typealias SelectImagesBlock = (selectImages : UIImage)->Void

class PopUpView: UIView, UITableViewDelegate, UITableViewDataSource , UIGestureRecognizerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    var tableView : UITableView?
    let titleArray = ["拍照", "从相册中选择","取消"]
    static let manager = PopUpView.init(frame: UIScreen.mainScreen().bounds)
    var photoArray = [AnyObject]()
    
    //单张选择
    var selectBlock : SelectBlock?
    //多张张选择
    var selectImagesBlock : SelectImagesBlock?
    
    let picker: UIImagePickerController = UIImagePickerController()
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.3)
        self.tableView = UITableView.init(frame: frame, style: UITableViewStyle.Plain)
        tableView!.delegate = self;
        tableView!.dataSource = self;
        tableView!.registerNib(UINib.init(nibName: "HerdViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView!.registerNib(UINib.init(nibName: "ButtonCell", bundle: nil), forCellReuseIdentifier: "buttonCell")
        tableView!.showsVerticalScrollIndicator = false
        tableView!.showsHorizontalScrollIndicator = false
        tableView!.tableFooterView = UIView.init()
        tableView!.bounces = false
        tableView!.contentInset = UIEdgeInsetsMake(2, 0, 0, 0)
        
        self.addSubview(self.tableView!)
        
        tableView!.translatesAutoresizingMaskIntoConstraints = false
        let leftConstraint = NSLayoutConstraint(item: tableView!,
                                                attribute: .Right,
                                                relatedBy: .Equal,
                                                toItem: self,
                                                attribute: .Right,
                                                multiplier: 1,
                                                constant: 0)
        
        let bottomConstraint = NSLayoutConstraint(item: tableView!,
                                                  attribute: .Bottom,
                                                  relatedBy: .Equal,
                                                  toItem: self,
                                                  attribute: .Bottom,
                                                  multiplier: 1,
                                                  constant: 0.0)
        let rigthConstraint = NSLayoutConstraint(item: tableView!,
                                                 attribute: .Left,
                                                 relatedBy: .Equal,
                                                 toItem: self,
                                                 attribute: .Left,
                                                 multiplier: 1,
                                                 constant: 0.0)
        let heightConstraint = NSLayoutConstraint(item: tableView!,
                                                  attribute: .Height,
                                                  relatedBy: .Equal,
                                                  toItem: nil,
                                                  attribute: .NotAnAttribute,
                                                  multiplier: 1,
                                                  constant: 204)
        
        self.addConstraints([rigthConstraint,leftConstraint,bottomConstraint,heightConstraint])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return HerdViewCell.HerdViewCells(tableView,indexPath: indexPath,identifier: "cell")
        }
        
        return ButtonCell.ButtonCells(tableView, indexPath: indexPath, identifier: "buttonCell",title: titleArray[indexPath.row - 1])
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 70
        }
        return 44
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 1: //相机
            self.goCamera()
        case 2: //相册
            PhotoAlbumMamager.sharedInstance.pushPhotoViewController(self)
        default: break
            
        }
        self.dissmiss()
    }
    
    func goCamera(){
        
        //先设定sourceType为相机，然后判断相机是否可用（ipod）没相机，不可用将sourceType设定为相片库
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            let picker = UIImagePickerController()
            picker.sourceType = .Camera
            picker.delegate = self
            self.dissmiss()
            self.window!.rootViewController!.presentViewController(picker, animated: true, completion: nil)
        }else {
            let alerview = UIAlertView.init(title: "提示", message: "相机不可用", delegate: nil, cancelButtonTitle: "OK")
            alerview.show()
        }
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print("\(info)")
        self.selectBlock?(selectImage: info[UIImagePickerControllerOriginalImage] as! UIImage)
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func getSelectImage(selectBlock : SelectBlock?) -> Void {
        self.selectBlock = selectBlock
        dissmiss()
    }
    
    func getSelectImages(selectBlock : SelectImagesBlock?) -> Void {
        self.selectImagesBlock = selectBlock
        dissmiss()
    }
    
    class func show() {
        
        let window = UIApplication.sharedApplication().keyWindow
        let view = PopUpView.manager
        view.tableView!.transform = CGAffineTransformMakeTranslation(0, 204)
        view.alpha = 0
        window!.addSubview(view)
        UIView.animateWithDuration(0.2) {
            view.alpha = 1
            view.tableView!.transform = CGAffineTransformIdentity
        }
    }
    
    func dissmiss() {
        let view = PopUpView.manager
        UIView.animateWithDuration(0.2, animations: {
            view.alpha = 0
            view.tableView!.transform = CGAffineTransformMakeTranslation(0, 184)
        }) { (f) in
            view.removeFromSuperview()
        }
        
    }
    
    class func dismiss() {
        
        let view = PopUpView.manager
        view.dissmiss()
        
    }
    
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    
}
