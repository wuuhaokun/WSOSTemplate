//
//  WSNetworkUtils.swift
//  shareba_business
//
//  Created by 吳招坤 on 2018/9/19.
//  Copyright © 2018年 WU CHAO KUN All rights reserved.
//
//import Alamofire
import Reachability

class WSNetworkUtils {
    public var canReach = true
    public var noNetworkMessage:String = "沒有網路"
    
    static let sharedInstance = WSNetworkUtils()
    let reachability = Reachability()
    init() {
        reachability?.whenReachable = { [weak self] reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
            self?.canReach = true
        }
        reachability?.whenUnreachable = { [weak self] _ in
            print("Not reachable")
            self?.canReach = false
            NotificationCenter.default.post(name: WSNETWORK_CHANGE_NOTIFICATION, object: self)
        }
        
        do {
            try reachability?.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    

    
//    private let manager: NetworkReachabilityManager?
//    private var reachable: Bool = false
//    private func listenForReachability() {
//        self.manager?.listener = { [unowned self] status in
//            switch status {
//            case .notReachable:
//                self.reachable = false
//            case .reachable(_), .unknown:
//                self.reachable = true
//            }
//            NotificationCenter.default.post(name: WSNETWORK_CHANGE_NOTIFICATION, object: self)
//        }
//        self.manager?.startListening()
//    }
//
//    func isConnected() -> Bool {
//        return reachable
//    }
}
