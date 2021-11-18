//
//  SettingTableViewController.swift
//  FoodManager
//
//  Created by ESAKI MAKOTO on 2021/11/17.
//

import UIKit
import SVProgressHUD
import Firebase
import FirebaseAuthUI
import FirebaseOAuthUI
import FirebaseEmailAuthUI
import FirebaseFacebookAuthUI
import FirebaseGoogleAuthUI
import MessageUI

class SettingTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FUIAuthDelegate, MFMailComposeViewControllerDelegate {
    
    var authUI: FUIAuth { get { return FUIAuth.defaultAuthUI()!}}
    var dateDeleteAlert: UIAlertController!
    var accountDeleteAlert: UIAlertController!
    
    var sections = ["マニュアル", "アップデート", "フィードバック", "アカウント", "デリート"]
    var manual = ["説明書", "よくある質問"]
    var update = ["更新のお知らせ", "更新予定"]
    var feedback = ["お問い合わせ", "障害情報"]
    var account = ["サインアウト"]
    var delete = ["登録してきたデータを全て削除", "アカウント削除"]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "settingCell")
        self.authUI.delegate = self
        let providers: [FUIAuthProvider] = [FUIOAuth.appleAuthProvider(),FUIGoogleAuth(authUI: self.authUI),FUIFacebookAuth(authUI: self.authUI),FUIOAuth.twitterAuthProvider(),FUIEmailAuth()]
        self.authUI.providers = providers
        dateDeleteAlert = UIAlertController(title: "データ削除" , message: "本当にデータを削除しますか？削除するとお客様が登録してきたデータは元に戻せません。", preferredStyle: .alert)
        let cancelAction1 = UIAlertAction(title: "キャンセル", style: .default, handler: nil)
        let deleteAction1 = UIAlertAction(title: "削除する", style: .default) { alert in
            Firestore.firestore().collection(Collection.documentPath).getDocuments { (querySnapShot, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                } else {
                    for document in querySnapShot!.documents {
                        document.reference.delete()
                    }
                }
            }
        }
        dateDeleteAlert.addAction(cancelAction1)
        dateDeleteAlert.addAction(deleteAction1)
        accountDeleteAlert = UIAlertController(title: "アカウント削除" , message: "本当にアカウントを削除しますか？削除するとお客様のアカウント情報は元に戻せません。", preferredStyle: .alert)
        let cancelAction2 = UIAlertAction(title: "キャンセル", style: .default, handler: nil)
        let deleteAction2 = UIAlertAction(title: "削除する", style: .default) { alert in
            Auth.auth().currentUser?.delete{ error in
                if error == nil {
                    self.performSegue(withIdentifier: "Login", sender: nil)
                } else {
                    print(error!.localizedDescription)
                }
            }
        }
        accountDeleteAlert.addAction(cancelAction2)
        accountDeleteAlert.addAction(deleteAction2)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 0
        if section == 0 {
            rows = manual.count
        } else if section == 1 {
            rows = update.count
        } else if section == 2 {
            rows = feedback.count
        } else if section == 3 {
            rows = account.count
        } else if section == 4 {
            rows = delete.count
        }
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath)
        var text = ""
        if indexPath.section == 0 {
            text = manual[indexPath.row]
        } else if indexPath.section == 1 {
            text = update[indexPath.row]
        } else if indexPath.section == 2 {
            text = feedback[indexPath.row]
        } else if indexPath.section == 3 {
            text = account[indexPath.row]
        } else if indexPath.section == 4 {
            text = delete[indexPath.row]
        }
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.textLabel?.text = text
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                performSegue(withIdentifier: "Manual", sender: nil)
            } else if indexPath.row == 1 {
                performSegue(withIdentifier: "Question", sender: nil)
            }
        }
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                performSegue(withIdentifier: "UpdateNotice", sender: nil)
            } else if indexPath.row == 1 {
                performSegue(withIdentifier: "ScheduledToBeUpdated", sender: nil)
            }
            
        }
        if indexPath.section == 2 {
            if indexPath.row == 0 {
                if MFMailComposeViewController.canSendMail() {
                    let mailViewController = MFMailComposeViewController()
                    mailViewController.mailComposeDelegate = self
                    let toRecipents = ["esaki.portfolio@gmail.com"]
                    mailViewController.setToRecipients(toRecipents)
                    self.present(mailViewController, animated: true, completion: nil)
                } else {
                    print("送信できません。")
                }
            } else if indexPath.row == 1 {
                performSegue(withIdentifier: "FailureInformation", sender: nil)
            }
        }
        if indexPath.section == 3 {
            if indexPath.row == 0 {
                try! Auth.auth().signOut()
                performSegue(withIdentifier: "Login", sender: nil)
            }
        }
        if indexPath.section == 4 {
            if indexPath.row == 0 {
                self.present(self.dateDeleteAlert, animated: true, completion: nil)
            } else if indexPath.row == 1 {
                self.present(self.accountDeleteAlert, animated: true, completion: nil)
            }
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("キャンセル")
            break
        case .saved:
            print("下書き保存")
            break
        case .sent:
            print("送信成功")
            break
        case .failed:
            print("送信失敗")
            break
        default:
            break
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
}
