//
//  HomeViewController.swift
//  FoodManager
//
//  Created by ESAKI MAKOTO on 2021/10/29.
//

import UIKit
import FirebaseFirestore

class HomeViewController: UIViewController {

    @IBOutlet weak var totalValue: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        Firestore.firestore().collection(Const.FoodPath).whereField("plice", notIn: ["あ"]).getDocuments() { querySnapshot, error in
//        if let error = error {
//                print(error)
//                return
//            } else {
//                for document in querySnapshot!.documents {
//                    let documentPlice = document.data()["plice"] as! Int
//                    self.totalValue.text = (documentPlice as NSNumber).stringValue + "円"
//                }
//            }
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Firestore.firestore().collection(Const.FoodPath).whereField("plice", notIn: ["あ"]).getDocuments() { querySnapshot, error in
        if let error = error {
                print(error)
                return
            } else {
                for document in querySnapshot!.documents {
                    let documentPlice = document.data()["plice"] as! Int
                    self.totalValue.text = (documentPlice as NSNumber).stringValue + "円"
                }
            }
        }
    }
}
