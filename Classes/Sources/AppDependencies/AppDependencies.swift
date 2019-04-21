//
//  AppDependencies.swift
//  shareba_business
//
//  Created by 吳招坤 on 2018/7/2.
//  Copyright © 2018年 TSAI CHENG HENG. All rights reserved.
//

import Foundation
import UIKit

public class AppDependencies {
    
    var appDependenciesBase :WSBaseAppDependencies?
    
    public init(appDependenciesBase:WSBaseAppDependencies) {
        self.appDependenciesBase = appDependenciesBase
        //起動監聽網路狀況功能
        WSNetworkUtils.sharedInstance
    }
    
    public func installRootViewControllerIntoWindow(_ window: UIWindow) -> UIViewController? {
        return self.appDependenciesBase?.installRootViewControllerIntoWindow(window)
    }
    
    public func rootViewControllerMakeVisible(_ window:UIWindow ,viewController:UIViewController?) {
        self.appDependenciesBase?.rootViewControllerMakeVisible(window, viewController:viewController)
    }
    
}
