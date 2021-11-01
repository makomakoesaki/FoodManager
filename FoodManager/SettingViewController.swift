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

    @IBOutlet weak var displayNameTextField: UITextField!
    
    var authUI: FUIAuth { get { return FUIAuth.defaultAuthUI()!}}
    
    @IBAction func handoleChangeButton(_ sender: Any) {
        if let displayName = displayNameTextField.text {
            if displayName.isEmpty {
                SVProgressHUD.showError(withStatus: "表示名を入力して下さい。")
                return
            }
            let user = Auth.auth().currentUser
            if let user = user {
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = displayName
                changeRequest.commitChanges { error in
                    if let error = error {
                        print(error)
                        return
                    }
                    SVProgressHUD.showSuccess(withStatus: "表示名を変更しました。")
                }
            }
        }
        self.view.endEditing(true)
    }
    
    @IBAction func handoleLogoutButton(_ sender: Any) {
        try! Auth.auth().signOut()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.authUI.delegate = self
        let providers: [FUIAuthProvider] = [FUIEmailAuth(),FUIGoogleAuth(authUI: self.authUI),FUIFacebookAuth(authUI: self.authUI)]
        self.authUI.providers = providers
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let user = Auth.auth().currentUser
        if let user = user {
            self.displayNameTextField.text = user.displayName
        }
    }
}
