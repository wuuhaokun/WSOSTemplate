//
//  WSFBSignIn.swift
//  used-car
//
//  Created by Apple on 2019/4/29.
//  Copyright © 2019 Apple. All rights reserved.
//
/*
import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

class WSFBSignIn: NSObject {

    static let sharedInstance = WSFBSignIn()
    let fbLoginManager = LoginManager()
    
    override init() {
        super.init()
    }
    
    open func signIn() {
        //注意這個from: nil 一原本要傳UIViewcontroller
        fbLoginManager.logIn(permissions: ["public_profile", "email"], from: nil, handler: { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            guard let accessToken = AccessToken.current else {
                print("Failed to get access token")
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            print(accessToken.tokenString )
            // Perform login by calling Firebase APIs
            Auth.auth().signInAndRetrieveData(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    //self.present(alertController, animated: true, completion: nil)
                    return
                }

                // Present the main view
                //if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MainView") {
                //    UIApplication.shared.keyWindow?.rootViewController = viewController
                //    self.dismiss(animated: true, completion: nil)
                //}

            })
            
        })
        
    }
    
    open func signOut() {
        fbLoginManager.logOut()
    }
    
}
*/
