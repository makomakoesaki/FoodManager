//
//  FoodInputScreenViewController.swift
//  FoodManager
//
//  Created by ESAKI MAKOTO on 2021/10/29.
//

import UIKit
import FirebaseFirestore
import Firebase
import SVProgressHUD

class FoodInputScreenViewController: UIViewController, UITextFieldDelegate {

    var listener: ListenerRegistration?
    var foodData: FoodData!
    var foodLength: Int = 10
    var numLength: Int = 6
    var pliceLength: Int = 6
    
    @IBOutlet weak var foodText: UITextField!
    @IBOutlet weak var numberText: UITextField!
    @IBOutlet weak var pliceText: UITextField!
    
    @IBAction func registerButton(_ sender: Any) {
        if let food = foodText.text {
            
            if food.isEmpty {
                SVProgressHUD.showError(withStatus: "品名を入力して下さい。")
                SVProgressHUD.dismiss(withDelay: 1)
                return
            } else if food.count > foodLength {
                SVProgressHUD.showError(withStatus: "品名は10文字以内で入力して下さい。")
                SVProgressHUD.dismiss(withDelay: 1)
                return
            } else if Double(food) != nil {
                SVProgressHUD.showError(withStatus: "品名は文字を入力して下さい。")
                SVProgressHUD.dismiss(withDelay: 1)
                return
            }
            if let number = numberText.text {
                if number.isEmpty {
                    SVProgressHUD.showError(withStatus: "個数を入力して下さい。")
                    SVProgressHUD.dismiss(withDelay: 1)
                    return
                } else if number.count > numLength {
                    SVProgressHUD.showError(withStatus: "個数は2桁に収めて下さい。")
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
                    else if plice.count > pliceLength {
                        SVProgressHUD.showError(withStatus: "値段は20000円に収めて下さい。")
                        SVProgressHUD.dismiss(withDelay: 1)
                        return
                    }
                    let intPlice = Int((plice as NSString).doubleValue)
                    Firestore.firestore().collection(Const.FoodPath).whereField("food", in: [food]).getDocuments() { (querySnapshot, error) in
                        if let error = error {
                            print("\(error)")
                            return
                        } else {
                            for document in querySnapshot!.documents {
                                let calendar = Calendar(identifier: .gregorian)
                                let timestamp = Timestamp()
                                let date: Date = timestamp.dateValue()
                                let day = calendar.component(.day, from: date)
                                let documentDate = document.data()["date"] as! Timestamp
                                let documentDay: Date = documentDate.dateValue()
                                let dcumentDay = calendar.component(.day, from: documentDay)
                                if day == dcumentDay {
                                    let documentNumber = document.data()["number"] as! Int
                                    let documentPlice = document.data()["plice"] as! Int
                                    let totalNumber = documentNumber + Int((number as NSString).doubleValue)
                                    if totalNumber > 100 {
                                        SVProgressHUD.showError(withStatus: "個数の合計値が100を超えています。")
                                        SVProgressHUD.dismiss(withDelay: 2)
                                        return
                                    }
                                    let totalPlice = documentPlice + Int((plice as NSString).doubleValue)
                                    if totalPlice > 99999 {
                                        SVProgressHUD.showError(withStatus: "値段の合計値が50000円を超えています。")
                                        SVProgressHUD.dismiss(withDelay: 2)
                                        return
                                    }
                                    let foodDic = ["date": Firebase.Timestamp(), "number": totalNumber, "plice": totalPlice] as [String : Any]
                                    Firestore.firestore().collection(Const.FoodPath).document(document.documentID).updateData(foodDic)
                                } else {
                                    return
                                }
                            }
                        }
                    }
                    Firestore.firestore().collection(Const.FoodPath).addDocument(data:["date": Firebase.Timestamp(), "food": food, "number": intNumber, "plice": intPlice])
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
