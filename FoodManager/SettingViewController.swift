//
//  SettingViewController.swift
//  FoodManager
//
//  Created by ESAKI MAKOTO on 2021/10/29.
//

import UIKit
import SVProgressHUD
import Firebase
import FirebaseAuthUI
import FirebaseEmailAuthUI
import FirebaseFacebookAuthUI
import FirebaseGoogleAuthUI

class SettingViewController: UIViewController, FUIAuthDelegate {
    
    var authUI: FUIAuth { get { return FUIAuth.defaultAuthUI()!}}
    
    @IBAction func handoleLogoutButton(_ sender: Any) {
        try! Auth.auth().signOut()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.authUI.delegate = self
        let providers: [FUIAuthProvider] = [FUIEmailAuth(),FUIGoogleAuth(authUI: self.authUI),FUIFacebookAuth(authUI: self.authUI)]
        self.authUI.providers = providers
    }
}
