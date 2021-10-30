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
        }
        if let number = numberText.text {
            if number.isEmpty {
                SVProgressHUD.showError(withStatus: "個数を入力して下さい。")
                SVProgressHUD.dismiss(withDelay: 1)
                return
            }
        }
        if let plice = pliceText.text {
            if plice.isEmpty {
                SVProgressHUD.showError(withStatus: "値段を入力して下さい。")
                SVProgressHUD.dismiss(withDelay: 1)
                return
            }
        }
//        if foodData.food == food {
//            let numbers = number + number
//            let plices = plice + plice
//            let postRef = Firestore.firestore().collection(Const.FoodPath).document(foodData.id)
//            let updateValue1: FieldValue
//            let updateValue2: FieldValue
//            updateValue1 = FieldValue.arrayUnion([numbers])
//            updateValue2 = FieldValue.arrayUnion([plices])
//            postRef.updateData(["food": updateValue1, "plice": updateValue2])
//            let foodRef = Firestore.firestore().collection(Const.FoodPath).document(foodData.id)
//            let foodDic = ["food": food, "number": number, "plice": plice]
//            foodRef.setData(foodDic)
//        }
        SVProgressHUD.showSuccess(withStatus: "登録しました。")
        SVProgressHUD.dismiss(withDelay: 1)
        foodText.text = ""
        numberText.text = ""
        pliceText.text = ""
        pliceText.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        numberText.keyboardType = UIKeyboardType.numberPad
        pliceText.keyboardType = UIKeyboardType.numberPad
        foodText.delegate = self
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
