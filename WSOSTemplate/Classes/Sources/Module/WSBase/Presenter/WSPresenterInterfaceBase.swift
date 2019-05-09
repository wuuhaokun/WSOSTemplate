//
//  WSPresenterInterfaceBase.swift
//  shareba_business
//
//  Created by 吳招坤 on 2018/7/2.
//  Copyright © 2018年 WU CHAO KUN All rights reserved.
//

import UIKit

public protocol WSPresenterInterfaceBase {
    
    func fetchCacheData(_ entitiesData: (([Any],SBErrorType) -> Void)!)
    func fetchData(_ entitiesData: (([Any],SBErrorType) -> Void)!, _ parameter:Any?)
    func fetchMoreData(_ entitiesData: (([Any],[Any],SBErrorType) -> Void)!, _ parameter:Any?)
    
    func closeViewController()
    func popViewController()
    func popToRootViewController()
    func dismissToRootViewController()
    func dismiss()
    func createViewController() -> UIViewController
    
    func presentWireframe(classMainName:String, vc: UIViewController, param:Any?)
    func pushWireframe(classMainName:String, vc: UIViewController, param:Any?)
    func presentNavigationWireframe(classMainName:String, vc: UIViewController, param:Any?)
    
}
