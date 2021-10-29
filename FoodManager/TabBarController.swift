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
        // authUIのデリゲート
        self.authUI.delegate = self
        //認証に使用するプロバイダの選択
        let providers: [FUIAuthProvider] = [FUIGoogleAuth(authUI: self.authUI),FUIFacebookAuth(authUI: self.authUI),FUIEmailAuth()]
        self.authUI.providers = providers
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        // FirebaseUIのViewの取得
        let authViewController = self.authUI.authViewController()
        // FirebaseUIのViewの表示
        self.present(authViewController, animated: true, completion: nil)
        // Do any additional setup after loading the view.
    }
    
    //　認証画面から離れたときに呼ばれる（キャンセルボタン押下含む）
    public func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?){
        // 認証に成功した場合
        if error == nil {
            self.performSegue(withIdentifier: "Home", sender: nil)
        } else {
        //失敗した場合
            print("error")
        }
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
