//
//  TabBarController.swift
//  FoodManager
//
//  Created by ESAKI MAKOTO on 2021/10/29.
//

import UIKit
import Firebase
import FirebaseAuthUI
import FirebaseEmailAuthUI
import FirebaseFacebookAuthUI
import FirebaseGoogleAuthUI

class TabBarController: UITabBarController,UITabBarControllerDelegate,FUIAuthDelegate {

    var authUI: FUIAuth { get { return FUIAuth.defaultAuthUI()!}}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.authUI.delegate = self
        let providers: [FUIAuthProvider] = [FUIEmailAuth(),FUIGoogleAuth(authUI: self.authUI),FUIFacebookAuth(authUI: self.authUI)]
        self.authUI.providers = providers
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            let authViewController = self.authUI.authViewController()
            authViewController.modalPresentationStyle = .fullScreen
            self.present(authViewController, animated: true, completion: nil)
            // Do any additional setup after loading the view.
        }
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
