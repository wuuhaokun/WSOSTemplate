//
//  WSVersionViewController.swift
//  shareba_business
//
//  Created by 吳招坤 on 2018/7/27.
//  Copyright © 2018年 TSAI CHENG HENG. All rights reserved.
//

import UIKit

public class WSVersionViewController: UIViewController {

    private lazy var contentImageView: UIImageView = {
        let contentImageView = UIImageView()
        contentImageView.image = UIImage.init(named: "LaunchScreen")
        contentImageView.contentMode = .scaleAspectFill
        contentImageView.backgroundColor = WSColor.darkGrey2
        return contentImageView
    }()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAutolayout()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerNotifycation()
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       WSBecomeActive(notification: nil)
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unregisterNotifycation()
    }
    
    func setupUI() {
        view.addSubview(contentImageView)
    }
    
    func setupAutolayout() {
        contentImageView.frame = self.view.bounds
        self.view.backgroundColor = UIColor.red
    }
    
    func registerNotifycation() {
        let notificationName = Notification.Name(rawValue: "WSBecomeActive")
        NotificationCenter
            .default
            .addObserver(self,selector:#selector(WSBecomeActive(notification:)),
                         name: notificationName, object: nil)
    }
    
    func unregisterNotifycation() {
        //如果不需要的话，记得把相应的通知注册给取消，避免内存浪费或奔溃
        let notificationName = Notification.Name(rawValue: "WSBecomeActive")
        NotificationCenter.default.removeObserver(notificationName)
    }
    
    @objc func WSBecomeActive(notification: Notification?) {
        let title:String = WSlocalizedString.localizedString(key: "new_version_prompt")
        let content:String = WSlocalizedString.localizedString(key: "an_upgraded_version")
        let alertController = UIAlertController(title: title, message:content, preferredStyle: UIAlertController.Style.alert)
        let okAlertAction = UIAlertAction(title: NSLocalizedString("ok", comment: "ok"), style: UIAlertAction.Style.default) { (alertAction) in
            let iTunesLink = "https://itunes.apple.com/us/app/apple-store/id1372628493?mt=8"
            let appSetting = URL(string:iTunesLink)
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appSetting!, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
            }
        }
        alertController.addAction(okAlertAction)
        present(alertController, animated: true, completion: nil)
    }
    
}
