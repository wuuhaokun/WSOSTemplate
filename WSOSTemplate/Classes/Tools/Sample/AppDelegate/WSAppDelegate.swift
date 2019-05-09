//
//  AppDelegate.swift
//  used-car
//
//  Created by Apple on 2019/4/22.
//  Copyright © 2019 Apple. All rights reserved.
//
/*
import UIKit
import Firebase
import GoogleSignIn
import LineSDK
import UserNotifications
import FBSDKCoreKit
//千萬別移除了
//APNS AuthKey資料
//Name:UsedCarAuthKey
//Key ID:8NTV8ZCPSV
//Services Apple Push Notifications service (APNs)


//注意這個使用時，要打開的
//@UIApplicationMain
class WSAppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        //google 登入使用的
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID

        //Line登入使用的
        if let channelID = Bundle.main.infoDictionary?["LINE Channel ID"] as? String,
            let _ = Int(channelID) {
            LoginManager.shared.setup(channelID: channelID, universalLinkURL: nil)
        }
        else {
            fatalError("Please set correct channel ID in Config.xcconfig file.")
        }

        //推播功能
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        //Solicit permission from user to receive notifications
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (_, error) in
            guard error == nil else{
                print(error!.localizedDescription)
                return
            }
        }

        //get application instance ID
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
            }
        }

        application.registerForRemoteNotifications()

        if CPUserCarStatus.getToken() != "" {
            let dependenciesItemArray:[AppDependenciesItem]  = [AppDependenciesItem(classMainName: "WSHome", tabTitle: "ViewControler", tabImageName: "home", tabSelectedImage: "home",tabBarViewClass:"ccc"),AppDependenciesItem(classMainName: "WSTableView", tabTitle: "TableView", tabImageName: "home", tabSelectedImage: "home",tabBarViewClass:"ccc")]
            WSBaseShareFunction.createTabBarStyle(self.window!, dependenciesItemArray)
        }
        else {
            WSBaseShareFunction.createViewStyle(self.window!, classMainName:"CPLogin")
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    //為了Google login加入的
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
        -> Bool {
            let path:String = url.absoluteString
            if path.contains("line3rdp.com.carplus.usedcar") {
                //Line 登入時使用的 先註解掉的之後要打開
                return LoginManager.shared.application(application, open: url, options: options)
            }
            else {
                //google登入時使用
                return GIDSignIn.sharedInstance().handle(url,sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: [:])
            }
            //facebook 登入使用的
            //let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
            //return handled
            
    }
    //Line 登入使用
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return LoginManager.shared.application(application, open: userActivity.webpageURL)
    }
    //推播功能功能
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }

        // Print full message.
        print(userInfo)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
}

//推播功能
extension WSAppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo

        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }

        // Print full message.
        print(userInfo)

        // Change this to your preferred presentation option
        completionHandler([])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }

        // Print full message.
        print(userInfo)

        completionHandler()
    }

}

extension WSAppDelegate: MessagingDelegate{

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")

        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }

    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }

    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        Messaging.messaging().apnsToken = deviceToken as Data
    }
    
}
*/
