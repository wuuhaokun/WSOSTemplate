//
//  WSViewControllerBase.swift
//  shareba_business
//
//  Created by 吳招坤 on 2018/7/2.
//  Copyright © 2018年 WU CHAO KUN All rights reserved.
//

import UIKit
import AMScrollingNavbar
import MBProgressHUD
import Toast_Swift

open class WSViewControllerBase : ScrollingNavigationViewController , WSViewInterfaceBase {

    open lazy var nodataInfoLabel: UILabel = {
        let nodataInfoLabel = UILabel()
        nodataInfoLabel.font = UIFont.boldSystemFont(ofSize: 18)
        nodataInfoLabel.textAlignment = .center
        nodataInfoLabel.text = WSlocalizedString.string(key: "There is no information")
        //self.view.addSubview(nodataInfoLabel)
        nodataInfoLabel.isHidden = true
        return nodataInfoLabel
    }()
    
    open var baseViewControllerDelegate: WSViewControlBaseDelegate?
    open var entitySectionsArray: [Any] = []
    open var eventHandler : WSPresenterInterfaceBase?
    open var param : Any?
    open weak var WSParent:UIViewController? = nil
    //public var noNetworkMessage:String = "No network!!"
    override open func viewDidLoad() {
        super.viewDidLoad()
        setupBaseUI();
        setBaseNavigationItem();
        buildCacheData {
            //這裡加載入資料後，需更新的UI
            //ToDo
            //DispatchQueue.main.async(execute: {
            self.reloadEntityData(finished:{ [weak self] in
                self?.baseViewControllerDelegate?.fetchDataFinished()
                })
            //})
        }
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerNotification()
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !WSNetworkUtils.sharedInstance.canReach {
            self.showNoNetworkToast()
        }
    }
    
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unregisterNotification()
    }
    
    // MARK: Private method(自己新加的功能)
    func setupBaseUI() {
        self.nodataInfoLabel.isHidden = true
        //nodataInfoLabel.snp.makeConstraints { make in
        //    make.top.equalTo(self.view).offset(16)
        //    make.width.equalTo(self.view)
        //    make.height.equalTo(21)
        //}
    }
    
    open func setBaseNavigationItem() {
    }
    
    open func registerNotification() {
        NotificationCenter
            .default
            .addObserver(self,selector:#selector(refreshData(notification:)),
                                  name: WSFRESH_DATA_NOTIFICATION, object: nil)
        NotificationCenter
            .default
            .addObserver(self,selector:#selector(loginNotification(notification:)),
                                  name: WSLOGIN_NOTIFICATION, object: nil)
        NotificationCenter
            .default
            .addObserver(self,selector:#selector(handleNetworkChange(notification:)), name: WSNETWORK_CHANGE_NOTIFICATION, object: nil)
        NotificationCenter
            .default
            .addObserver(self,selector:#selector(refreshDataAndView(notification:)),name: WSFRESH_DATA_AND_VIEW_NOTIFICATION, object: nil)
    }
    
    open func unregisterNotification() {
        //如果不需要的话，记得把相应的通知注册给取消，避免内存浪费或奔溃
        NotificationCenter.default.removeObserver(WSFRESH_DATA_NOTIFICATION)
        NotificationCenter.default.removeObserver(WSLOGIN_NOTIFICATION)
        NotificationCenter.default.removeObserver(WSNETWORK_CHANGE_NOTIFICATION)
        NotificationCenter.default.removeObserver(WSFRESH_DATA_AND_VIEW_NOTIFICATION)
    }
    
    func buildCacheData(then: @escaping () -> Void) {
        // Simulate an async request
        //DispatchQueue.global().async {
            // Data from `data.json`
            self.fetchCacheData({ [weak self] entitiesApiData,error in
                self?.entitySectionsArray.removeAll()
                self?.entitySectionsArray = entitiesApiData as! [WSApiDataModel]
                //DispatchQueue.main.async {
                    then()
                //}
            })
        //}
    }
    
    open func reloadEntityData(finished:@escaping () -> Void) {
        
        self.fetchData({  [weak self] entitiesApiData,error in
            self?.entitySectionsArray.removeAll()
            self?.entitySectionsArray = entitiesApiData as! [WSApiDataModel]
            if self?.entitySectionsArray.count ?? 0 <= 0 {
                print("")
                self?.nodataInfoLabel.isHidden = false
            }
            finished()
        })
        
//        if self is WSTabelViewControllerBase {
//            self.showHud(superView:(self as! WSTabelViewControllerBase).tableView)
//            self.fetchData({  [weak self] entitiesApiData,error in
//                self?.entitySectionsArray.removeAll()
//                self?.entitySectionsArray = entitiesApiData as! [WSApiDataModel]
//                self?.hideHUD(superView:(self as! WSTabelViewControllerBase).tableView)
//                finished()
//            });
//        }
//        else {
//            self.showHud()
//            self.fetchData({  [weak self] entitiesApiData,error in
//                self?.entitySectionsArray.removeAll()
//                self?.entitySectionsArray = entitiesApiData as! [WSApiDataModel]
//                self?.hideHUD()
//                finished()
//            });
//        }

    }
    
    // MARK: ViewInterface
    //目前沒有共用的Interface
    
    // MARK: WSNotification
    @objc func refreshData(notification: Notification) {
        self.reloadEntityData {
        }
    }
    
    @objc func loginNotification(notification: Notification) {
        self.reloadEntityData {
        }
    }
    
    @objc func handleNetworkChange(notification: Notification) {
        print("handleNetworkChange")
        self.showNoNetworkToast()
    }
    
    @objc func refreshDataAndView(notification: Notification) {
        print("viewFinishedRefreshData")
        self.baseViewControllerDelegate?
            .viewFinishedRefreshData(notification:notification)
    }
    
    // MARK: overWrite 有需要則可過載，抓取資料的部份
    open func fetchCacheData(_ entitiesData: (([Any],SBErrorType) -> Void)!) {
        eventHandler?.fetchCacheData(entitiesData)
    }
    
    open func fetchData(_ entitiesData: (([Any],SBErrorType) -> Void)!, _ parameter:Any? = nil) {
        eventHandler?.fetchData(entitiesData, parameter)
    }
    
    open func fetchMoreData(_ entitiesData: (([Any],[Any],SBErrorType) -> Void)!, _ parameter:Any? = nil) {
        eventHandler?.fetchMoreData(entitiesData, parameter)
    }
    // MARK: WSViewControlBaseDelegate
    open func registerCellClass() {
        //由子類決定是否實做
    }
    open func fetchDataFinished() {
        //由子類決定是否實做
    }
    
    open func resizeTableView(frame:CGRect) {
        //給予子類別決定是否實作
    }
    
    open func viewFinishedRefreshData(notification: Notification) {
        //給予子類別決定是否實作
    }
    
}

extension UIViewController {
    /// Call this once to dismiss open keyboards by tapping anywhere in the view controller
    public func setupHideKeyboardOnTap() {
        self.view.addGestureRecognizer(self.endEditingRecognizer())
        self.navigationController?
            .navigationBar.addGestureRecognizer(self.endEditingRecognizer())
    }
    
    /// Dismisses the keyboard from self.view
    private func endEditingRecognizer() -> UIGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        tap.cancelsTouchesInView = false
        return tap
    }
    
    public func statusBarHeight() ->CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }
    
    public func navigationBarHeight(navController:UINavigationController?) ->CGFloat {
        var height : CGFloat = 0.0
        if let rect = navController?.navigationBar.frame {
            height = CGFloat(rect.height)
        }
        return height
    }
    
    //status+NavigationBar的高度
    public var statusAndNavigationBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.size.height +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
    
    public func tabBarHeight(tabController:UITabBarController?) -> CGFloat {
        var height : CGFloat = 0.0
        if let rect = tabController?.tabBar.frame {
            height = rect.height
        }
        return height
    }
    
    
    


    
    //    var topbarHeight: CGFloat {
    //        return UIApplication.shared.statusBarFrame.size.height +
    //            (self.navigationController?.navigationBar.frame.height ?? 0.0)
    //    }
    public func showOKAlert(preferredStyle:UIAlertController.Style = UIAlertController.Style.alert , title:String = "", message:String, superController:UIViewController, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        let ok = UIAlertAction(title: WSlocalizedString.localizedString(key: "ok"), style: .default) {  (UIAlertAction) in
            if handler != nil {
                handler!(UIAlertAction)
            }
        }
        alert.addAction(ok)
        superController.present(alert, animated: true, completion: nil)
    }
    
    public func showOKCancelAlert(preferredStyle:UIAlertController.Style = UIAlertController.Style.alert ,title:String = "", message:String, superController:UIViewController, okHandler: ((UIAlertAction) -> Void)? = nil, cancelHandler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        let ok = UIAlertAction(title: WSlocalizedString.localizedString(key: "ok"), style: .default) {  (UIAlertAction) in
            if okHandler != nil {
                okHandler!(UIAlertAction)
            }
        }
        alert.addAction(ok)
        let cancel = UIAlertAction(title: WSlocalizedString.localizedString(key: "cancel"), style: .default) { (UIAlertAction) in
            if cancelHandler != nil {
                cancelHandler!(UIAlertAction)
            }
        }
        alert.addAction(cancel)
        superController.present(alert, animated: true, completion: nil)
    }
    
    public func showHud(_ message:String = "", superView:UIView? = nil, afterDelay: Int = 30, isUserInteractionEnabled:Bool = true) {
        var hud :MBProgressHUD? = nil
        if superView == nil {
            hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        else {
            hud = MBProgressHUD.showAdded(to: superView!, animated: true)
        }
        if message == "" {
            hud!.bezelView.style = .solidColor
        }
        hud!.bezelView.backgroundColor =  UIColor.clear
        hud!.label.text = message
        hud!.isUserInteractionEnabled = isUserInteractionEnabled
        hud!.hide(animated: true, afterDelay: TimeInterval(afterDelay))
    }
    
    public func hideHUD(superView:UIView? = nil) {
        if superView == nil {
            MBProgressHUD.hide(for: self.view, animated: true)
            return
        }
        MBProgressHUD.hide(for: superView!, animated: true)
    }
    
    func showNoNetworkToast() {
        self.view.makeToast(WSNetworkUtils.sharedInstance.noNetworkMessage, duration: 3.0, position: .bottom)
    }
    
}
