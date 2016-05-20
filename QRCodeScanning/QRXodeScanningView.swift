//
//  QRXodeScanningView.swift
//  QRCodeScanning
//
//  Created by 云族佳 on 16/5/17.
//  Copyright © 2016年 温仲斌. All rights reserved.
//

import UIKit

import AVFoundation

typealias ScanResults = ((results : String)->Void)

class QRXodeScanningView: UIView,AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate {
    //会话
    let captureSession = AVCaptureSession()
    //获取相机实例
    let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    //显示层
    var videoPreviewLayer : AVCaptureVideoPreviewLayer?
    //处理线程
    let dispatchQueue : dispatch_queue_t = dispatch_queue_create("com.myqueue.www", DISPATCH_QUEUE_SERIAL)
    //提示label
    let maskText = CATextLayer()
    //扫描动画
    let basA = CABasicAnimation.init(keyPath: "bounds")
    
    var scanResults : ScanResults?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.loadCapture()
        self.loadToobar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadCapture() {
        //输入流
        var input : AVCaptureDeviceInput?
        do {
            //初始化输入流
            input = try AVCaptureDeviceInput.init(device: captureDevice)
        }catch let error{
            print(error)
            let al = UIAlertView.init(title: "提示", message: "是否打开相机权限?", delegate: self, cancelButtonTitle: "去打开", otherButtonTitles: "不了")
            al.show()
            return
        }
        //放大
        do {
            try self.captureDevice!.lockForConfiguration()
        } catch _ {
            NSLog("Error: lockForConfiguration.");
        }
        self.captureDevice!.videoZoomFactor = 4.0
        self.captureDevice!.unlockForConfiguration()
        //初始化输出流
        let captureMetadataOutput = AVCaptureMetadataOutput.init()
        
        //添加输入流
        self.captureSession.addInput(input!)
        //添加输出流
        self.captureSession.addOutput(captureMetadataOutput)
        
        //创建队列
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatchQueue)
        
        //设置元数据类型
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code]
        
        //设置扫描区域
        captureMetadataOutput.rectOfInterest = self.getRectOfInterest()
        
        self.captureSession.sessionPreset = AVCaptureSessionPresetHigh
        
        
        print(self.getRectOfInterest())
        //创建输出对象
        self.videoPreviewLayer = AVCaptureVideoPreviewLayer.init(session: self.captureSession)
        self.videoPreviewLayer?.backgroundColor = UIColor.init(white: 0, alpha: 0.7).CGColor
        self.videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.videoPreviewLayer?.frame = UIScreen.mainScreen().bounds
        self.layer.addSublayer(self.videoPreviewLayer!)
    }
    
    func getRectOfInterest() -> CGRect {
        let rect = CGRectMake(self.center.x - 2 * CGRectGetWidth(UIScreen.mainScreen().bounds) / 6, self.center.y - CGRectGetWidth(UIScreen.mainScreen().bounds) / 2, 2 * CGRectGetWidth(UIScreen.mainScreen().bounds) / 3, 2 * CGRectGetWidth(UIScreen.mainScreen().bounds) / 3)
        let maxRect = UIScreen.mainScreen().bounds
        let x = rect.origin.y / CGRectGetHeight(maxRect)
        let y = rect.origin.x / CGRectGetWidth(maxRect)
        let w = CGRectGetWidth(rect) / CGRectGetHeight(maxRect)
        let h = CGRectGetWidth(rect) / CGRectGetWidth(maxRect)
        
        return CGRectMake(x, y, w, h)
    }
    
    func loadToobar() {
        let toobar = UIToolbar()
        toobar.barStyle = .Black
        toobar.translatesAutoresizingMaskIntoConstraints = false
        
        
        let leftB = UIButton.init(type: UIButtonType.Custom)
        leftB.setImage(UIImage.init(named: "qrcode_scan_btn_photo_down"), forState: UIControlState.Normal)
        leftB.imageView?.contentMode = .ScaleAspectFit
        leftB.bounds = CGRectMake(0, 0, 60, 60)
        leftB.addTarget(self, action: #selector(photoSelect), forControlEvents: UIControlEvents.TouchUpInside)
        
        let leftBar = UIBarButtonItem.init(customView:leftB)
        
        let rigthB = UIButton.init(type: UIButtonType.Custom)
        rigthB.setImage(UIImage.init(named: "qrcode_scan_btn_flash_down"), forState: UIControlState.Normal)
        rigthB.imageView?.contentMode = .ScaleAspectFit
        rigthB.bounds = CGRectMake(0, 0, 60, 60)
        rigthB.addTarget(self, action: #selector(hasFlash), forControlEvents: UIControlEvents.TouchUpInside)
        let rigthBar = UIBarButtonItem.init(customView: rigthB)
        
        
        let bar = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        toobar.setItems([bar,leftBar,bar,bar,bar,rigthBar,bar], animated: true)
        
        self.addSubview(toobar)
        
        let left = NSLayoutConstraint.init(item: toobar, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        
        let rigth = NSLayoutConstraint.init(item: toobar, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        
        let bottom = NSLayoutConstraint.init(item: toobar, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        
        let higth = NSLayoutConstraint.init(item: toobar, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 64)
        
        self.addConstraints([left,rigth,bottom,higth])
        
    }
    
    func loadLayer(fillLayer : CALayer, myRect : CGRect) {
        //上左
        let maskTopLeft = CALayer()
        maskTopLeft.contents = UIImage.init(named: "scan_1")?.CGImage
        maskTopLeft.bounds = CGRectMake(0, 0, 20, 20)
        maskTopLeft.position = CGPointMake(myRect.origin.x, myRect.origin.y)
        //上右
        let maskTopRigth = CALayer()
        maskTopRigth.contents = UIImage.init(named:"scan_2")?.CGImage
        maskTopRigth.bounds = CGRectMake(0, 0, 20, 20)
        maskTopRigth.position =  CGPointMake(myRect.origin.x + CGRectGetWidth(myRect),myRect.origin.y)
        //下左
        let maskBommLeft = CALayer()
        maskBommLeft.contents = UIImage.init(named: "scan_3")?.CGImage
        maskBommLeft.bounds = CGRectMake(0, 0, 20, 20)
        maskBommLeft.position = CGPointMake(myRect.origin.x, myRect.origin.y + CGRectGetWidth(myRect))
        //下右
        let maskBommRigth = CALayer()
        maskBommRigth.contents = UIImage.init(named:"scan_4")?.CGImage
        maskBommRigth.bounds = CGRectMake(0, 0, 20, 20)
        maskBommRigth.position = CGPointMake(myRect.origin.x + CGRectGetWidth(myRect),myRect.origin.y + CGRectGetWidth(myRect))
        //扫描线条
        let maskLink = CALayer()
        maskLink.bounds = CGRectMake(0, 0, 2 * CGRectGetWidth(UIScreen.mainScreen().bounds) / 3, 0)
        maskLink.contents = UIImage.init(named: "scan_net")?.CGImage
        maskLink.position = CGPointMake(myRect.origin.x + CGRectGetWidth(maskLink.bounds) / 2, myRect.origin.y)
        maskLink.anchorPoint = CGPointMake(0.5, 0)
        
        maskText.string = "请将二维码置于扫描框内"
        maskText.contentsScale = UIScreen.mainScreen().scale
        maskText.fontSize = 15
        maskText.foregroundColor = UIColor.blueColor().CGColor
        maskText.alignmentMode = kCAAlignmentCenter
        maskText.bounds = CGRectMake(0, 0, CGRectGetWidth(myRect), 20)
        
        maskText.position = CGPointMake(self.center.x, myRect.origin.y + CGRectGetWidth(myRect) + 40)
        maskText.wrapped = true
        
        fillLayer.addSublayer(maskTopLeft)
        fillLayer.addSublayer(maskTopRigth)
        fillLayer.addSublayer(maskBommLeft)
        fillLayer.addSublayer(maskBommRigth)
        fillLayer.addSublayer(maskLink)
        fillLayer.addSublayer(maskText)
        
        //避免重复添加
        maskLink.removeAllAnimations()
        //添加扫描动画
        maskLink.addAnimation(self.animation(), forKey: "bounds")
    }
    
    func animation() -> CABasicAnimation {
        //扫描动画
        basA.toValue = NSValue.init(CGRect: CGRectMake(0, 0, 2 * CGRectGetWidth(UIScreen.mainScreen().bounds) / 3, 2 * CGRectGetWidth(UIScreen.mainScreen().bounds) / 3))
        basA.duration = 2
        basA.removedOnCompletion = false;
        basA.repeatCount = Float.infinity
        return basA
    }
    
    override func drawRect(rect: CGRect) {
        //中间镂空的矩形框
        let myRect = CGRectMake(self.center.x - 2 * CGRectGetWidth(UIScreen.mainScreen().bounds) / 6,  self.center.y - CGRectGetWidth(UIScreen.mainScreen().bounds) / 2, 2 * CGRectGetWidth(UIScreen.mainScreen().bounds) / 3, 2 * CGRectGetWidth(UIScreen.mainScreen().bounds) / 3)
        //背景
        let path = UIBezierPath.init(rect: rect)
        //镂空
        let circlePath = UIBezierPath.init(roundedRect: myRect, cornerRadius: 5)
        path.appendPath(circlePath)
        path.usesEvenOddFillRule = true
        let fillLayer = CAShapeLayer()
        fillLayer.path = path.CGPath;
        fillLayer.fillRule = kCAFillRuleEvenOdd;
        fillLayer.fillColor = UIColor.init(white: 0, alpha: 0.3).CGColor
        self.layer.addSublayer(fillLayer)
        
        self.loadLayer(fillLayer, myRect: myRect)
    }
    
    func startRunning() {
        //开始会话
        dispatch_async(dispatchQueue) {
            self.captureSession.startRunning()
        }
    }
    
    func stopRunning() {
        self.captureSession.stopRunning()
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        guard metadataObjects.count > 0 else {
            return
        }
        
        let readableCodeObject = metadataObjects.first as! AVMetadataMachineReadableCodeObject
        dispatch_async(dispatch_get_main_queue(), {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            self.stopRunning()
            if let scan = self.scanResults {
                scan(results: readableCodeObject.stringValue)
            }
            let al = UIAlertView.init(title: "扫描结果", message:readableCodeObject.stringValue, delegate: self, cancelButtonTitle: "Canal" ,otherButtonTitles: "OK")
            al.tag = 100
            al.show()
        })
        
    }
    
    //识别图片二维码
    func QRcode(image : UIImage) {
        
        let detector = CIDetector.init(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        var detectorArray : [AnyObject]?
        detectorArray = detector.featuresInImage(CIImage.init(image: image)!)
        
        guard detectorArray?.count > 0 else {
            let al = UIAlertView.init(title: "🐶🐱🐔🐑🐰🐯", message: "该图片没有包含一个二维码", delegate: nil, cancelButtonTitle: "OK")
            al.show()
            return
        }
        
        let feature = detectorArray!.first as? CIQRCodeFeature
        dispatch_async(dispatch_get_main_queue(), {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            self.stopRunning()
            if let scan = self.scanResults {
                scan(results: (feature?.messageString)!)
            }
            let al = UIAlertView.init(title: "扫描结果", message:(feature?.messageString)!, delegate: self, cancelButtonTitle: "Canal" ,otherButtonTitles: "OK")
            al.tag = 100
            al.show()
        })
        
        
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 0 && alertView.tag != 100{
            let url = NSURL.init(string: UIApplicationOpenSettingsURLString)
            if UIApplication.sharedApplication().canOpenURL(url!) {
                UIApplication.sharedApplication().openURL(url!)
            }
        }
        if buttonIndex != 0 && alertView.tag == 100 {
            self.startRunning()
        }
    }
    
    func hasFlash() {
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        if device.hasFlash && device.hasTorch {
            do {
                try device.lockForConfiguration()
            }catch let error {
                fatalError("\(error)")
            }
            if device.flashMode == .On {
                device.flashMode = .Off
                device.torchMode = .Off
            }else {
                device.flashMode = .On
                device.torchMode = .On
            }
        }
        device.unlockForConfiguration()
    }
    
    func photoSelect() {
        dispatch_async(dispatch_get_main_queue()) {
            PhotoAlbumMamager.sharedInstance.pushPhotoViewController(self)
        }
        PopUpView.manager.getSelectImages {
            (selectImage) in
            self.QRcode(selectImage)
        }
    }
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    
}
