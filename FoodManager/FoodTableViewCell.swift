//
//  FoodTableViewCell.swift
//  FoodManager
//
//  Created by ESAKI MAKOTO on 2021/10/29.
//

import UIKit

class FoodTableViewCell: UITableViewCell {

    @IBOutlet weak var foodLabel: UILabel!
    @IBOutlet weak var numberlabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setFoodData(_ foodData: FoodData) {
        self.foodLabel.text = foodData.food
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        self.numberlabel.text = (foodData.number as NSNumber).stringValue + "個"
        self.priceLabel.text = numberFormatter.string(from: NSNumber(integerLiteral: foodData.plice))! + "円"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日 HH時mm分"
        let dateString = dateFormatter.string(from: foodData.date)
        self.dateLabel.text = dateString
    }
}

