//
//  DocumentRegisterViewController.swift
//  FoodManager
//
//  Created by ESAKI MAKOTO on 2021/10/29.
//

import UIKit
import FirebaseFirestore
import Firebase
import SVProgressHUD

class DocumentRegisterViewController: UIViewController, UITextFieldDelegate {
    
    var productNameLength: Int = 14
    var priceLength: Int = 8
    
    @IBOutlet weak var productNameText: UITextField!
    @IBOutlet weak var priceText: UITextField!
    
    @IBAction func registerButton(_ sender: Any) {
        if let productName = productNameText.text {
            if productName.isEmpty {
                SVProgressHUD.showError(withStatus: "品名を入力して下さい。")
                SVProgressHUD.dismiss(withDelay: 1)
                return
            } else if productName.count > productNameLength {
                SVProgressHUD.showError(withStatus: "品名は14文字以内で入力して下さい。")
                SVProgressHUD.dismiss(withDelay: 1)
                return
            } else if Double(productName) != nil {
                SVProgressHUD.showError(withStatus: "品名は文字を入力して下さい。")
                SVProgressHUD.dismiss(withDelay: 1)
                return
            }
            if let price = priceText.text {
                if price.isEmpty {
                    SVProgressHUD.showError(withStatus: "金額を入力して下さい。")
                    SVProgressHUD.dismiss(withDelay: 1)
                    return
                }
                else if price.count > priceLength {
                    SVProgressHUD.showError(withStatus: "金額は8桁以内で入力して下さい。")
                    SVProgressHUD.dismiss(withDelay: 1)
                    return
                }
                let intPrice = Int((price as NSString).doubleValue)
                Firestore.firestore().collection(Collection.documentPath).addDocument(data:["timestamp": Firebase.Timestamp(), "productName": productName, "price": intPrice])
            }
        }
        SVProgressHUD.showSuccess(withStatus: "登録しました。")
        SVProgressHUD.dismiss(withDelay: 1)
        self.productNameText.text = ""
        self.priceText.text = ""
        self.priceText.endEditing(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.priceText.keyboardType = UIKeyboardType.numberPad
        self.productNameText.delegate = self
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
