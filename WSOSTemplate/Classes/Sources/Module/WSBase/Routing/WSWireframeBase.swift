//
//  WSWireframeBase.swift
//  shareba_business
//
//  Created by 吳招坤 on 2018/7/2.
//  Copyright © 2018年 WU CHAO KUN All rights reserved.
//

import Foundation
import UIKit
//import ESTabBarController_swift
import AMScrollingNavbar

open class WSWireframeBase : NSObject {
    
    open var basePresenter : WSPresenterBase?
    open var baseViewController : WSViewControllerBase?
    
    override required public init() {
        print("init")
    }
    
    func createViperModule() -> Void {
        var classMainName:String = String(describing: type(of: self))
        classMainName = classMainName.replacingOccurrences(of: "Wireframe", with: "")
        //產生WSPresenterBase類別物件
        let basePresenter:WSPresenterBase = WSBaseShareFunction.createClassObject(classMainName: classMainName, suffixName:"Presenter") as! WSPresenterBase
        
        //產生WSInteractorBase類別物件
        let baseInteractor:WSInteractorBase = WSBaseShareFunction.createClassObject(classMainName: classMainName, suffixName:"Interactor") as! WSInteractorBase
        
        //產生WSDataManagerBase類別物件
        let basedataManager:WSDataManagerBase = WSBaseShareFunction.createClassObject(classMainName: classMainName, suffixName:"DataManager") as! WSDataManagerBase
        baseInteractor.dataManager = basedataManager
        basedataManager.baseDataManagerDelegate = basedataManager as WSDataManagerDelegateBase
        
        self.basePresenter = basePresenter;
        baseInteractor.output = basePresenter
        basePresenter.interactor = baseInteractor
        basePresenter.wireframe = self
    }
    
    open func closeViewController() {
        (self.basePresenter?.userInterface as! UIViewController).navigationController?.popViewController(animated: true)
    }
    
    open func popViewController() {
        (self.basePresenter?.userInterface as! UIViewController).navigationController?.popViewController(animated: true)
    }
    
    open func popToRootViewController() {
        (self.basePresenter?.userInterface as! UIViewController).navigationController?.popToRootViewController(animated: true)
    }
    
    open func dismissViewController() {
        //        func dismissViewControllers() {
        //
        //            guard let vc = self.presentingViewController else { return }
        //
        //            while (vc.presentingViewController != nil) {
        //                vc.dismiss(animated: true, completion: nil)
        //            }
        //        }
        
    }
    
    open func dismissToRootViewController() {
        //let view:UIView = (self.basePresenter?.userInterface as! UIViewController).view
        //view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        //获取根VC
        var rootVC = (self.basePresenter?.userInterface as! UIViewController).presentingViewController
        while let parent = rootVC?.presentingViewController {
            rootVC = parent
        }
        //释放所有下级视图
        rootVC?.dismiss(animated: true, completion: nil)
    }
    
    open func dismiss() {
        (self.basePresenter?.userInterface as! UIViewController).dismiss(animated: true, completion: nil)
    }
    
    open func presentTabbarStyleFromWindow(_ window: UIWindow, dependenciesItem:AppDependenciesItem) -> UINavigationController {
        var viewController :WSViewControllerBase?
        var navigationController :ScrollingNavigationController?
        let appName = WSBaseShareFunction.getAppName().replacingOccurrences(of: "-", with: "_")
        let viewControllerClassName:NSString = appName + "." + dependenciesItem.classMainName! + "ViewController" as NSString
        guard let viewControllerTypeObject = NSClassFromString(viewControllerClassName as String)! as? WSViewControllerBase.Type
            else{
                NSLog("无法转换成UITableViewController")
                return navigationController!
        }
        viewController = viewControllerTypeObject.init()
        viewController?.baseViewControllerDelegate = viewController as? WSViewControlBaseDelegate
        viewController?.eventHandler = basePresenter
        baseViewController = viewController
        basePresenter?.userInterface = viewController
        
        //WSBaseContentView //用來修改TabBarItem的顏色等等設定
//        let contentView:ESTabBarItemContentView? = (WSBaseShareFunction.createClassObject(classMainName: "WSBaseContentView", suffixName:"") as? ESTabBarItemContentView)!
//使用ESTabBarItem 要打開。不要移除這個
//        baseViewController?.tabBarItem = ESTabBarItem.init(contentView!,title: dependenciesItem.tabTitle, image: UIImage(named: dependenciesItem.tabImageName!), selectedImage: UIImage(named: dependenciesItem.tabSelectedImage!))
        
        baseViewController?.tabBarItem = UITabBarItem.init(title: dependenciesItem.tabTitle, image: UIImage(named: dependenciesItem.tabImageName!),tag: 0)
        
        navigationController = ScrollingNavigationController.init(rootViewController: baseViewController!)
        return navigationController!
    }

    open func presentViewStyleFromWindow(_ window: UIWindow, dependenciesItem:AppDependenciesItem) -> UIViewController {
        var viewController :WSViewControllerBase?
        let appName = WSBaseShareFunction.getAppName().replacingOccurrences(of: "-", with: "_")
        let viewControllerClassName:NSString = appName + "." + dependenciesItem.classMainName! + "ViewController" as NSString
        guard let viewControllerTypeObject = NSClassFromString(viewControllerClassName as String)! as? WSViewControllerBase.Type
            else{
                NSLog("无法转换成UITableViewController")
                return nil!
        }
        viewController = viewControllerTypeObject.init()
        viewController?.baseViewControllerDelegate = viewController as? WSViewControlBaseDelegate
        viewController?.eventHandler = basePresenter
        basePresenter?.userInterface = viewController
        return viewController!
    }
    
//    open func presentNavigationStyleFromWindow(_ window: UIWindow, dependenciesItem:AppDependenciesItem) -> UIViewController {
//        var viewController :WSViewControllerBase?
//        let appName = WSBaseShareFunction.getAppName().replacingOccurrences(of: "-", with: "_")
//        let viewControllerClassName:NSString = appName + "." + dependenciesItem.classMainName! + "ViewController" as NSString
//        guard let viewControllerTypeObject = NSClassFromString(viewControllerClassName as String)! as? WSViewControllerBase.Type
//            else{
//                NSLog("无法转换成UITableViewController")
//                return nil!
//        }
//        viewController = viewControllerTypeObject.init()
//        viewController?.baseViewControllerDelegate = viewController as? WSViewControlBaseDelegate
//        viewController?.eventHandler = basePresenter
//        basePresenter?.userInterface = viewController
//        return viewController!
//    }
    
    open func pushViewController(vc: UIViewController , param:Any? = nil) -> Void {
        self.createViperModule()
        var classMainName:String = String(describing: type(of: self))
        classMainName = classMainName.replacingOccurrences(of: "Wireframe", with: "")
        print(classMainName)
        //產生WSViewControllerBase類別物件
        let viewController:WSViewControllerBase = WSBaseShareFunction.createClassObject(classMainName: classMainName, suffixName:"ViewController") as! WSViewControllerBase
        viewController.baseViewControllerDelegate = viewController as? WSViewControlBaseDelegate
        viewController.eventHandler = self.basePresenter;
        self.basePresenter?.userInterface = viewController;
        viewController.WSParent = vc
        vc.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //僅產生ViewController物件
    open func createViewController() -> UIViewController {
        self.createViperModule()
        var classMainName:String = String(describing: type(of: self))
        classMainName = classMainName.replacingOccurrences(of: "Wireframe", with: "")
        print(classMainName)
        //產生WSViewControllerBase類別物件
        let viewController:WSViewControllerBase = WSBaseShareFunction.createClassObject(classMainName: classMainName, suffixName:"ViewController") as! WSViewControllerBase
        viewController.baseViewControllerDelegate = viewController as? WSViewControlBaseDelegate
        viewController.eventHandler = self.basePresenter;
        self.basePresenter?.userInterface = viewController;
        return viewController
    }

    @objc open func presentNavigationViewController(vc: UIViewController , param:Any? = nil) -> Void {
        self.createViperModule()
        var classMainName:String = String(describing: type(of: self))
        classMainName = classMainName.replacingOccurrences(of: "Wireframe", with: "")
        print(classMainName)
        //產生WSViewControllerBase類別物件
        let viewController:WSViewControllerBase = WSBaseShareFunction.createClassObject(classMainName: classMainName, suffixName:"ViewController") as! WSViewControllerBase
        viewController.param = param
        viewController.WSParent = vc
        viewController.baseViewControllerDelegate = viewController as? WSViewControlBaseDelegate
        viewController.eventHandler = self.basePresenter;
        self.basePresenter?.userInterface = viewController;
        let navigationController = UINavigationController(rootViewController: viewController)
        vc.present(navigationController, animated: true, completion: nil)
    }
    
    open func presentViewController(vc: UIViewController , param:Any? = nil) -> Void {
        self.createViperModule()
        var classMainName:String = String(describing: type(of: self))
        classMainName = classMainName.replacingOccurrences(of: "Wireframe", with: "")
        print(classMainName)
        //產生WSViewControllerBase類別物件
        let viewController:WSViewControllerBase = WSBaseShareFunction.createClassObject(classMainName: classMainName, suffixName:"ViewController") as! WSViewControllerBase
        viewController.baseViewControllerDelegate = viewController as? WSViewControlBaseDelegate
        viewController.WSParent = vc
        viewController.eventHandler = self.basePresenter;
        self.basePresenter?.userInterface = viewController;
        //let nav = UINavigationController(rootViewController: viewController)
        vc.present(viewController, animated: true, completion: nil)
    }
    
    //產生wirefrme
    open func presentWireframe(classMainName:String, vc: UIViewController , param:Any? = nil) {
        let baseWireframe:WSWireframeBase = WSBaseShareFunction.createClassObject(classMainName: classMainName, suffixName:"Wireframe") as! WSWireframeBase
        baseWireframe.presentViewController(vc: vc, param:param)
    }
    
    open func pushWireframe(classMainName:String , vc: UIViewController , param:Any? = nil) {
        let baseWireframe:WSWireframeBase = WSBaseShareFunction.createClassObject(classMainName: classMainName, suffixName:"Wireframe") as! WSWireframeBase
        baseWireframe.pushViewController(vc: vc, param:param)
    }
    
    open func presentNavigationWireframe(classMainName:String, vc: UIViewController , param:Any? = nil) {
        let baseWireframe:WSWireframeBase = WSBaseShareFunction.createClassObject(classMainName: classMainName, suffixName:"Wireframe") as! WSWireframeBase
        baseWireframe.presentNavigationViewController(vc: vc, param:param)
    }
    
}
