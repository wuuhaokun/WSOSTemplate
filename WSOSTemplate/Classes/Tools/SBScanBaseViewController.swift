//
//  SBScanBaseViewController.swift
//  shareba_business
//
//  Created by 吳招坤 on 2018/7/20.
//  Copyright © 2018年 WU CHAO KUN All rights reserved.
//

import UIKit
//import WSViewControllerBase
//import LBXScanViewControllerDelegate

open class WSScanBaseViewController: WSViewControllerBase , LBXScanViewControllerDelegate {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    open override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: LBXScanViewControllerDelegate
    open func scanFinished(scanResult: LBXScanResult, error: String?){
        NSLog("scanResult:\(scanResult)")
        self.dismiss(animated: false, completion: nil)
    }
    
    // MARK: Button action
    @objc open func cancelScanButtonAction () {
        //self.eventHandler?.popToRootViewController()
        //self.eventHandler?.dismissToRootViewController()
        self.eventHandler?.dismiss()
    }
    
}
