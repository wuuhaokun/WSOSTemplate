//
//  ViewStyleDependencies.swift
//  shareba_business
//
//  Created by 吳招坤 on 2018/7/2.
//  Copyright © 2018年 TSAI CHENG HENG. All rights reserved.
//

import Foundation
import UIKit

public class ViewStyleDependencies :WSBaseAppDependencies , AppDependenciesDelegate {
    
    override public func installRootViewControllerIntoWindow(_ window: UIWindow) -> UIViewController? {
        var navigationViewController :UIViewController?
        var index = 0
        for baseWireframe in baseWireframeArray {
            navigationViewController = baseWireframe.presentViewStyleFromWindow(window,dependenciesItem: baseDependenciesItemArray[index])
            index = index + 1
        }
        return navigationViewController
    }
    
}

public class NavigationStyleDependencies : ViewStyleDependencies {
    
    public override func rootViewControllerMakeVisible(_ window: UIWindow ,viewController:UIViewController?) {
        window.rootViewController = nil
        let navigationController = UINavigationController(rootViewController: viewController!)
        window.rootViewController = navigationController
        //window.rootViewController = viewController?.navigationController
        window.makeKeyAndVisible()
    }
    
}
