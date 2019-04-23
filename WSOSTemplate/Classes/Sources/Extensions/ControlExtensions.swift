//
//  ControlExtensions.swift
//  shareba_business
//
//  Created by 吳招坤 on 2018/6/28.
//  Copyright © 2018年 TSAI CHENG HENG. All rights reserved.
//

import UIKit
import Alamofire

//extension DaisyNet {
//    
//    static public func request1(
//        _ url: String,
//        method: HTTPMethod = .get,
//        params: Parameters? = nil,
//        dynamicParams: Parameters? = nil,
//        encoding: ParameterEncoding = URLEncoding.default,
//        headers: HTTPHeaders? = nil)
//        -> RequestTaskManager
//    {
//        return RequestManager.default.request(url, method: method, params: params, dynamicParams: dynamicParams, encoding: encoding, headers: headers)
//    }
//}
//extension UITableViewController {
//
//    public func showHudForTable(_ message: String) {
//        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//        hud.label.text = message
//        hud.bezelView.backgroundColor =  UIColor.clear
//        hud.isUserInteractionEnabled = false
//        hud.layer.zPosition = 2
//        self.tableView.layer.zPosition = 1
//    }
//
//}

//extension UIViewController {
//
////    public func showHudWithAfterDelay(_ message: String = "", afterDelay: Int) {
////        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
////        if message == "" {
////            hud.bezelView.style = .solidColor
////        }
////        hud.bezelView.backgroundColor =  UIColor.clear
////        hud.label.text = message
////        hud.isUserInteractionEnabled = false
////        hud.hide(animated: true, afterDelay: TimeInterval(afterDelay))
////    }
////
////    public func showHud(_ message: String = "") {
////        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
////        if message == "" {
////            hud.bezelView.style = .solidColor
////        }
////        hud.bezelView.backgroundColor =  UIColor.clear
////        hud.label.text = message
////        hud.isUserInteractionEnabled = false
////        hud.hide(animated: true, afterDelay: 180)
////    }
//
////    public func hideHUD() {
////        MBProgressHUD.hide(for: self.view, animated: true)
////    }
//
//    public func showHud(_ message:String = "", superView:UIView? = nil, afterDelay: Int = 180) {
//        var hud :MBProgressHUD? = nil
//        if superView == nil {
//            hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//        }
//        else {
//            hud = MBProgressHUD.showAdded(to: superView!, animated: true)
//        }
//        if message == "" {
//            hud!.bezelView.style = .solidColor
//        }
//        hud!.bezelView.backgroundColor =  UIColor.clear
//        hud!.label.text = message
//        hud!.isUserInteractionEnabled = false
//        hud!.hide(animated: true, afterDelay: TimeInterval(afterDelay))
//    }
//
//    public func hideHUD(superView:UIView? = nil) {
//        if superView == nil {
//            MBProgressHUD.hide(for: self.view, animated: true)
//            return
//        }
//        MBProgressHUD.hide(for: superView!, animated: true)
//    }
//
//}
