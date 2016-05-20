//
//  ViewController.swift
//  QRCodeScanning
//
//  Created by 云族佳 on 16/5/17.
//  Copyright © 2016年 温仲斌. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var v : QRXodeScanningView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.v = QRXodeScanningView(frame: self.view.bounds)
//        v!.scanResults = {(results)-> Void in
//            print(results)
//            let two = WebViewController()
//            two.sting = results
//            self.navigationController?.pushViewController(two, animated: true)
//        }
        self.view.addSubview(v!)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        v!.startRunning()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

