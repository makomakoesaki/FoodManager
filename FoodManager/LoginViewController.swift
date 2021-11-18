//
//  LoginViewController.swift
//  FoodManager
//
//  Created by ESAKI MAKOTO on 2021/10/31.
//

import UIKit
import FirebaseAuthUI
import FirebaseOAuthUI
import FirebaseEmailAuthUI
import FirebaseFacebookAuthUI
import FirebaseGoogleAuthUI

class LoginViewController: UIViewController {

    var authUI: FUIAuth { get { return FUIAuth.defaultAuthUI()!}}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.authUI.delegate = self
        let providers: [FUIAuthProvider] = [FUIOAuth.appleAuthProvider(),FUIGoogleAuth(authUI: self.authUI),FUIFacebookAuth(authUI: self.authUI),FUIOAuth.twitterAuthProvider(),FUIEmailAuth()]
        self.authUI.providers = providers
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser == nil {
            let authViewController = self.authUI.authViewController()
            authViewController.modalPresentationStyle = .fullScreen
            present(authViewController, animated: false, completion: nil)
        } else if Auth.auth().currentUser != nil {
            let tabBarController = storyboard?.instantiateViewController(withIdentifier: "Tab")
            tabBarController?.modalPresentationStyle = .fullScreen
            present(tabBarController!, animated: false, completion: nil)
        }
    }
}

extension LoginViewController: FUIAuthDelegate {
    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
        return LoginCustomViewController(authUI: authUI)
    }
}
