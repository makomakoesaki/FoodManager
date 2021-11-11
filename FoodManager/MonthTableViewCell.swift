//
//  HomeTableViewCell.swift
//  FoodManager
//
//  Created by ESAKI MAKOTO on 2021/11/10.
//

import UIKit
import FirebaseFirestore

class MonthTableViewCell: UITableViewCell {

    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var monthPlice: Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setPliceData(_ foodData: FoodData) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月"
        let dateString = formatter.string(from: foodData.date)
        self.monthLabel.text = dateString
//        Firestore.firestore().collection(Const.FoodPath).getDocuments { (snap, error) in
//            if let error = error {
//                print(error.localizedDescription)
//                return
//            } else {
//                for document in snap!.documents {
//                    let price = document.data()["plice"] as! Int
//                    self.monthPlice = price + self.monthPlice
//                }
//            }
//        }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        self.priceLabel.text = numberFormatter.string(from: NSNumber(integerLiteral: foodData.plice))! + "円"
    }
}
