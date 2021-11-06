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
    
    var loadPlice: Int!
        
    override func viewDidLoad() {
    }

    
    override func viewDidAppear(_ animated: Bool) {
        loadPlice = 0
        Firestore.firestore().collection(Const.FoodPath).getDocuments() { (querySnapshot, error) in
            if let error = error {
                print(error)
                return
            } else {
                for document in querySnapshot!.documents {
                    let documentPlice = document.data()["plice"] as! Int
                    let totalPlice = documentPlice + self.loadPlice
                    self.loadPlice = totalPlice
                    let formatter = NumberFormatter()
                    formatter.numberStyle = .decimal
                    self.totalValue.text = formatter.string(from: NSNumber(integerLiteral: totalPlice))! + "円"
                }
            }
        }
    }
}
