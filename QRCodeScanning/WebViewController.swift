//
//  WebViewController.swift
//  QRCodeScanning
//
//  Created by 云族佳 on 16/5/19.
//  Copyright © 2016年 温仲斌. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    var sting : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let webview = UIWebView.init(frame: self.view.bounds)
        webview.loadRequest(NSURLRequest.init(URL: NSURL.init(string: self.sting!)!))
        self.view.addSubview(webview)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
