//
//  WSBaseAppDependencies.swift
//  shareba_business
//
//  Created by 吳招坤 on 2018/6/29.
//  Copyright © 2018年 WU CHAO KUN All rights reserved.
//

import UIKit
//import ESTabBarController_swift

public struct AppDependenciesItem {
    
    public init(classMainName: String, tabTitle: String, tabImageName: String, tabSelectedImage: String,tabBarViewClass:String) {
        self.classMainName = classMainName
        self.tabTitle = tabTitle
        self.tabImageName = tabImageName
        self.tabSelectedImage = tabSelectedImage
        self.tabBarViewClass = tabBarViewClass
    }
    
    public let classMainName :String?
    public let tabTitle:String?
    public let tabImageName:String?
    public let tabSelectedImage:String?
    public let tabBarViewClass:String?

}

protocol AppDependenciesDelegate {
    
    func installRootViewControllerIntoWindow(_ window: UIWindow) -> UIViewController?
    func rootViewControllerMakeVisible(_ window: UIWindow ,viewController:UIViewController?)
}

public class WSBaseAppDependencies {
    
    var baseWireframeArray :[WSWireframeBase] = []
    var baseClassMainNameArray :[String] = []
    var baseDependenciesItemArray :[AppDependenciesItem] = []
    //var baseViewControllerDelegate: AppDependenciesDelegate?
    
    public init(dependenciesItemArray:[AppDependenciesItem]) {
        self.configureDependencies(dependenciesItemArray: dependenciesItemArray)
        //self.installRootViewControllerIntoWindow(UIApplication.shared.keyWindow!)
    }
    //建立所有VIPER下的物件需要由繼承類別實作
    public func installRootViewControllerIntoWindow(_ window: UIWindow) -> UIViewController? {
        return nil
    }
    //產生Wireframe類別
    internal func configureDependencies(dependenciesItemArray:[AppDependenciesItem]) {
        baseDependenciesItemArray = dependenciesItemArray
        for dependenciesItem in dependenciesItemArray {
            let baseWireframe:WSWireframeBase = (WSBaseShareFunction.createClassObject(classMainName: dependenciesItem.classMainName!, suffixName:"Wireframe") as? WSWireframeBase)!
            //產生WSPresenterBase,WSDataManagerBase,WSDataManagerBase類別物件
            baseWireframe.createViperModule()
            baseWireframeArray.append(baseWireframe)
        }
    }
    
    public func rootViewControllerMakeVisible(_ window: UIWindow ,viewController:UIViewController?) {
        window.rootViewController = nil
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
    
}

