//
//  WSLineSignIn.swift
//  used-car
//
//  Created by Apple on 2019/4/26.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import LineSDK

class WSLineSignIn:NSObject {

    static let sharedInstance = WSLineSignIn()
    
    override init() {
        super.init()
    }
    
    open func signIn() {
        //line 的登入部份
        LoginManager.shared.login(permissions: [.profile], in: nil) {
            result in
            switch result {
            case .success(let loginResult):
                print(loginResult.accessToken.value)
            // Do other things you need with the login result
            case .failure(let error):
                print(error)
            }
        }
    }
    
    open func signOut() {
        LoginManager.shared.logout(completionHandler: { result in
            switch result {
            case .success(let loginResult):
                print(loginResult)
            // Do other things you need with the login result
            case .failure(let error):
                print(error)
            }
        })
    }
    
}
