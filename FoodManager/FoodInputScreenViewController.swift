//
//  FoodInputScreenViewController.swift
//  FoodManager
//
//  Created by ESAKI MAKOTO on 2021/10/29.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import SVProgressHUD

class FoodInputScreenViewController: UIViewController, UITextFieldDelegate {

    var foodData: FoodData!
    var userName: User = Auth.auth().currentUser!
    
    @IBOutlet weak var foodText: UITextField!
    @IBOutlet weak var numberText: UITextField!
    @IBOutlet weak var pliceText: UITextField!
    
    @IBAction func registerButton(_ sender: Any) {
        if let food = foodText.text {
            if food.isEmpty {
                SVProgressHUD.showError(withStatus: "品名を入力して下さい。")
                SVProgressHUD.dismiss(withDelay: 1)
                return
            } else if Int(food) != nil {
                SVProgressHUD.showError(withStatus: "品名は文字を入力して下さい。")
                SVProgressHUD.dismiss(withDelay: 1)
                return
            }
            if let number = numberText.text {
                if number.isEmpty {
                    SVProgressHUD.showError(withStatus: "個数を入力して下さい。")
                    SVProgressHUD.dismiss(withDelay: 1)
                    return
                }
                let intNumber = Int((number as NSString).doubleValue)
                if let plice = pliceText.text {
                    if plice.isEmpty {
                        SVProgressHUD.showError(withStatus: "値段を入力して下さい。")
                        SVProgressHUD.dismiss(withDelay: 1)
                        return
                    }
                    let intPlice = Int((plice as NSString).doubleValue)
                    Firestore.firestore().collection(Const.FoodPath).whereField("food", isEqualTo: food).getDocuments() { (querySnapshot, error) in
                        if let error = error {
                            print("\(error)")
                            return
                        } else {
                            for document in querySnapshot!.documents {
                                let documentNumber = document.data()["number"] as! Int
                                let documentPlice = document.data()["plice"] as! Int
                                let totalNumber = documentNumber + intNumber
                                let totalPlice = documentPlice + intPlice
                                let foodDic = ["number": totalNumber, "plice": totalPlice]
                                Firestore.firestore().collection(Const.FoodPath).document(document.documentID).updateData(foodDic)
                            }
                        }
                    }
                    let newDocument = Firestore.firestore().collection(Const.FoodPath).document(foodData.id)
                    let foodsDic = ["userName": userName, "food": food, "number": intNumber, "plice": intPlice] as [String : Any]
                    newDocument.setData(foodsDic)
                }
            }
        }
        SVProgressHUD.showSuccess(withStatus: "登録しました。")
        SVProgressHUD.dismiss(withDelay: 1)
        self.foodText.text = ""
        self.numberText.text = ""
        self.pliceText.text = ""
        self.pliceText.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.numberText.keyboardType = UIKeyboardType.numberPad
        self.pliceText.keyboardType = UIKeyboardType.numberPad
        self.foodText.delegate = self
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
