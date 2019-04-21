//
//  WSTableViewPresenter.swift
//  CPMVPTemplate
//
//  Created by Apple on 2019/4/18.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Pods_WSOSTemplate_Example

class WSTableViewPresenter: WSPresenterBase, WSTableViewInteractorOutput, WSTableViewPresenterInterface {

    //public var interactor : WSInteractorInputBase?
    
    func test() -> Int {
        return (interactor as! WSTableViewInteractorInput).test()
    }
    
    //public var interactor : WSInteractorInputBase?
    //public var wireframe : WSWireframeBase?
    //public var userInterface : WSViewInterfaceBase?
    
}

/*
 open class WSPresenterBase : NSObject, WSInteractorOutputBase, WSPresenterInterfaceBase {
 
 public var interactor : WSInteractorInputBase?
 public var wireframe : WSWireframeBase?
 public var userInterface : WSViewInterfaceBase?
 
 override required public init() {
 print("init")
 }
 
 // MARK: InteractorOutput
 
 // MARK: ModuleInterface
 public func fetchCacheData(_ entitiesData: (([Any],SBErrorType) -> Void)!) {
 return (interactor?.fetchCacheData(entitiesData))!
 }
 
 public func fetchData(_ entitiesData: (([Any],SBErrorType) -> Void)!, _ parameter:Any? = nil) {
 interactor?.fetchData(entitiesData, parameter)
 }
 
 public func fetchMoreData(_ entitiesData: (([Any],[Any],SBErrorType) -> Void)!, _ parameter:Any? = nil) {
 interactor?.fetchMoreData(entitiesData, parameter)
 }
 
 public func closeViewController(){
 wireframe?.closeViewController()
 }
 
 public func popViewController(){
 wireframe?.popViewController()
 }
 
 public func popToRootViewController() {
 wireframe?.popToRootViewController()
 }
 
 public func dismissViewController() {
 wireframe?.dismissViewController()
 //        func dismissViewControllers() {
 //            guard let vc = self.presentingViewController else { return }
 //            while (vc.presentingViewController != nil) {
 //                vc.dismiss(animated: true, completion: nil)
 //            }
 //        }
 }
 
 public func dismissToRootViewController() {
 wireframe?.dismissToRootViewController()
 }
 
 public func dismiss() {
 wireframe?.dismiss()
 }
 
 public func createViewController() -> UIViewController {
 return (wireframe?.createViewController())!
 }
 
 //wireframe
 public func presentWireframe(classMainName:String, vc: UIViewController, param:Any?) {
 wireframe?.presentWireframe(classMainName:classMainName, vc: vc, param:param)
 }
 
 public func pushWireframe(classMainName:String, vc: UIViewController, param:Any? = nil) {
 wireframe?.pushWireframe(classMainName:classMainName, vc: vc, param:param)
 }
 
 public func presentNavigationWireframe(classMainName:String, vc: UIViewController, param:Any? = nil) {
 wireframe?.presentNavigationWireframe(classMainName:classMainName, vc: vc, param:param)
 }
 
 }

*/
