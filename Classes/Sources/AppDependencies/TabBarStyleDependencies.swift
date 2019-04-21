//
//  TabBarStyleDependencies.swift
//  shareba_business
//
//  Created by 吳招坤 on 2018/7/2.
//  Copyright © 2018年 TSAI CHENG HENG. All rights reserved.
//

import Foundation
import UIKit
//import ESTabBarController_swift

public class TabBarStyleDependencies : WSBaseAppDependencies , AppDependenciesDelegate {
    
    override public func installRootViewControllerIntoWindow(_ window: UIWindow) -> UIViewController? {
        //let tabBarController = LxTabBarController()//打開可支援左右滑動功能
        //let tabBarController = ESTabBarController()//使用ESTabBarController為基底
        let tabBarController = UITabBarController()//打開可使用系統預設之TabBarController
        var navigationViewControllerArray :[UIViewController] = []
        var index = 0
        for baseWireframe in baseWireframeArray {
            navigationViewControllerArray
                .append(baseWireframe
                    .presentTabbarStyleFromWindow(window,dependenciesItem: baseDependenciesItemArray[index]))
            index = index + 1
        }
        tabBarController.viewControllers = navigationViewControllerArray
        return tabBarController
    }
    
    public override func rootViewControllerMakeVisible(_ window: UIWindow ,viewController:UIViewController?) {
        //設定到那一頁的方式,預設為第1頁
        (viewController as! UITabBarController).selectedIndex = 0
        window.rootViewController = nil
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
    
    
}
