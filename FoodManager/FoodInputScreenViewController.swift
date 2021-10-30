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

class FoodInputScreenViewController: UIViewController {

    var foodData: FoodData!
    
    @IBOutlet weak var foodText: UITextField!
    @IBOutlet weak var numberText: UITextField!
    @IBOutlet weak var pliceText: UITextField!

    @IBAction func registerButton(_ sender: Any) {
        if let food = foodText.text {
            if food.isEmpty {
                SVProgressHUD.showError(withStatus: "食品を入力して下さい。")
                return
            } else if let number = numberText.text {
                if number.isEmpty {
                    SVProgressHUD.showError(withStatus: "個数を入力して下さい。")
                    return
                } else if let plice = pliceText.text {
                    if plice.isEmpty {
                        SVProgressHUD.showError(withStatus: "値段を入力して下さい。")
                        return
                    }
                    if foodData.food == food {
                        let numbers = number + number
                        let plices = plice + plice
                        let postRef = Firestore.firestore().collection(Const.FoodPath).document(foodData.id)
                        let updateValue1: FieldValue
                        let updateValue2: FieldValue
                        updateValue1 = FieldValue.arrayUnion([numbers])
                        updateValue2 = FieldValue.arrayUnion([plices])
                        postRef.updateData(["food": updateValue1, "plice": updateValue2])
                    }
                    let foodRef = Firestore.firestore().collection(Const.FoodPath).document(foodData.id)
                    let foodDic = ["food": food, "number": number, "plice": plice]
                    foodRef.setData(foodDic)
                } else {
                    SVProgressHUD.showSuccess(withStatus: "登録しました。")
                }
            }
        }
        let foodTableViewCell = storyboard?.instantiateViewController(withIdentifier: "Management")
        present(foodTableViewCell!, animated: false, completion: nil)
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
