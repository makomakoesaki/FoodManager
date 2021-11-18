//
//  MonthlyTotalAmountTableViewCell.swift
//  FoodManager
//
//  Created by ESAKI MAKOTO on 2021/11/10.
//

import UIKit
import FirebaseFirestore

class MonthlyTotalAmountTableViewCell: UITableViewCell {


    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setSumallyData(_ sumally: Sumally) {
        self.monthLabel.text = sumally.yyyyMM
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        self.priceLabel.text = formatter.string(from: NSNumber(integerLiteral: sumally.price))! + "円"
    }
}
