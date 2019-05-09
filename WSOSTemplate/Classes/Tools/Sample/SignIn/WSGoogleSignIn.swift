//
//  WSGoogleSignIn.swift
//  used-car
//
//  Created by Apple on 2019/4/24.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import GoogleSignIn

class WSGoogleSignIn:NSObject, GIDSignInUIDelegate, GIDSignInDelegate {

    static let sharedInstance = WSGoogleSignIn()
    
    override init() {
        super.init()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
    }
    
    open func signIn() {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    open func signOut() {
        GIDSignIn.sharedInstance()?.signOut()
    }
    
    //MARK: GIDSignIn Delegate
    open func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error)
            return
        }
        guard let authentication = user.authentication else {return}
        print(authentication.accessToken ?? "default value")
        
        let userId = user.userID                  // For client-side use only!
        print("User id is \(String(describing: userId))")
        let idToken = user.authentication.idToken // Safe to send to the server
        print("Authentication idToken is \(String(describing: idToken))")
        let fullName = user.profile.name
        print("User full name is \(String(describing: fullName))")
        let givenName = user.profile.givenName
        print("User given profile name is \(String(describing: givenName))")
        let familyName = user.profile.familyName
        print("User family name is \(String(describing: familyName))")
        let email = user.profile.email
        print("User email address is \(String(describing: email))")
    }
    
    // Finished disconnecting |user| from the app successfully if |error| is |nil|.
    open func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("ERROR ::\(error.localizedDescription)")
    }
    
    open func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        print("dismissing Google SignIn")
    }
    
    open func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        print("presenting Google SignIn")
    }
    
}
