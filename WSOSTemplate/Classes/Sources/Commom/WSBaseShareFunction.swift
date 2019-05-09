//
//  WSBaseShareFunction.swift
//  shareba_business
//
//  Created by 吳招坤 on 2018/7/1.
//  Copyright © 2018年 WU CHAO KUN All rights reserved.
//

import Foundation
import UIKit

open class WSBaseShareFunction {
    
    @objc public static func getAppName() -> String {
        let nameKey = "CFBundleName"
        let appName = Bundle.main.object(forInfoDictionaryKey: nameKey) as? String
        return appName!
    }

    @objc public static func createClassObject(classMainName:String, suffixName:String)-> AnyObject? {
        let appName = WSBaseShareFunction.getAppName().replacingOccurrences(of: "-", with: "_")
        let className:NSString = appName + "." + classMainName + suffixName as NSString
        guard let typeObject = NSClassFromString(className as String)! as? NSObject.Type
            else{
                print("無法轉換成UITableViewController")
                return nil
        }
        let baseClass:AnyObject = typeObject.init()
        return baseClass
    }//WSHomeManagerData
    
    @objc public static func cellReuseIdentifier(entitySections:[Any],indexPath: IndexPath)->String {
        let apiDataModel = entitySections[indexPath.section]
        let baseMode:WSModelBase = ((apiDataModel as! WSApiDataModel).body![indexPath.row] as? WSModelBase)!
        let  cellReuseIdentifier =  baseMode.prefixCell! + "Cell"
        return cellReuseIdentifier
    }
    //建立TabBar樣式的rootViewControler
    static public func createTabBarStyle(_ window:UIWindow, _ dependenciesItemArray:[AppDependenciesItem]) {
        var tabBarStyleViewController:UIViewController? = nil
        var tabBarStyleAppDependencies:AppDependencies? = nil
        if tabBarStyleAppDependencies == nil {
            tabBarStyleAppDependencies = AppDependencies(appDependenciesBase: TabBarStyleDependencies(dependenciesItemArray: dependenciesItemArray))
            tabBarStyleViewController = tabBarStyleAppDependencies?.installRootViewControllerIntoWindow(window)
        }
        tabBarStyleAppDependencies?.rootViewControllerMakeVisible(window, viewController:tabBarStyleViewController)
    }
    //建立ViewControler樣式
    @objc static public func createViewStyle(_ window:UIWindow, classMainName:String) {
        let dependenciesItem = AppDependenciesItem(classMainName: classMainName, tabTitle: "", tabImageName: "", tabSelectedImage: "",tabBarViewClass:"WSBase")
        let dependenciesItemArray:[AppDependenciesItem] = [dependenciesItem]
        var viewStyleViewController:UIViewController? = nil
        var viewStyleAppDependencies:AppDependencies? = nil
        if viewStyleAppDependencies == nil {
            viewStyleAppDependencies = AppDependencies(appDependenciesBase: ViewStyleDependencies(dependenciesItemArray: dependenciesItemArray))
            viewStyleViewController = viewStyleAppDependencies?.installRootViewControllerIntoWindow(window)
        }
        viewStyleAppDependencies?
            .rootViewControllerMakeVisible(window ,viewController:viewStyleViewController)
    }
    //建立含有Navigation的ViewControler
    @objc static public func createNavigationStyle(_ window:UIWindow, classMainName:String, params:Any = ""){
        let dependenciesItem = AppDependenciesItem(classMainName: classMainName, tabTitle: "", tabImageName: "", tabSelectedImage: "",tabBarViewClass:"WSBase")
        let dependenciesItemArray:[AppDependenciesItem] = [dependenciesItem]
        var navigationStyleViewController:UIViewController? = nil
        var navigationStyleDependencies:AppDependencies? = nil
        if navigationStyleDependencies == nil {
            navigationStyleDependencies = AppDependencies(appDependenciesBase: NavigationStyleDependencies(dependenciesItemArray: dependenciesItemArray))
            navigationStyleViewController = navigationStyleDependencies?.installRootViewControllerIntoWindow(window)
        }
        navigationStyleDependencies?
            .rootViewControllerMakeVisible(window ,viewController:navigationStyleViewController)
    }
}
